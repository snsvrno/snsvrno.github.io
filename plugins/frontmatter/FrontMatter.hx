package frontmatter;

using StringTools;

import site.Site;

class FrontMatter {

	private static inline var PLUGIN_NAME:String = "frontmatter";

	public static function scanFrontMatter(site:Site, ?options:Options) : Site {
		options = types.OptionsTools.fillWithValues(options, Options.defaults());
		debug(PLUGIN_NAME, c('options: ${options}'), Detailed);

		for (file in site.getArea(options.area)) {

			if (file.content.substring(0, options.seperator.length) == options.seperator) {
				var end = file.content.indexOf(options.seperator, options.seperator.length+1) + options.seperator.length;
				var matterContent = file.content.substring(0, end);
				file.content = file.content.substring(end);

				var data = parse(matterContent);
				debug(PLUGIN_NAME, c('${file.fileName} => $data'));

				var found = [];
				for (key => value in data) {
					file.metadata.set(key, value);
					found.push(key);
				}

			}

		}

		return site;
	}

	//////////////////////////////////////////////////////////////////////////////

	private static function parse(matter : String) : Map<String, types.Metadata> {
		var data : Map<String, types.Metadata> = new Map();
		var lines = matter.split("\n");
		lines.pop();
		lines.shift();
	
		var current : String = "";
		while(lines.length > 0) {
			var line = lines.shift();
			if (line.substring(0,1) == "-") {
				var value = types.MetadataTools.parse(clean( line.substring(1).trim() ));

				if (data.exists(current)) {
					var existing = data.get(current);
					switch(existing) {
						case MArray(val):
							val.push(value);
						case other:
							data.set(current, MArray([other, value]));
					}

				} else
					data.set(current, value);

			} else {

				var split = line.split(":");
				if (split.length > 1) {
					var key = split[0].trim();
					var val = types.MetadataTools.parse(clean(split[1].trim()));
					data.set(key, val);
				} else current = split[0].trim();

			}
		}

		return data;
	}

	private static function clean(string : String) : String {

		// removes parethesis
		if ((string.substring(0,1) == "\"" || string.substring(0,1) == "'")
			&& (string.substring(string.length-1) == "\"" || string.substring(string.length-1) == "'")) {
			string = string.substring(1,string.length-1);
		}

		return string;
	}

}
