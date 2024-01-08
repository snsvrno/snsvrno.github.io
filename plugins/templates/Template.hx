package templates;

import types.File;

using types.FileTools;
using types.MetadataTools;

class Template {

	private var tokens : Array<Token>;
	public var templates : Array<File>;

	public function new(file:File) {
		tokens = Parser.parse(file.content);
	}

	public function apply(file:File) : String {
		var content = "";

		for (t in tokens) switch (t) {

			case Text(text):
				content += text;

			case Var(name): switch(name) {
				case "content": content += file.content;
				case "site_root":
					var count = file.folder.split("/").length - 1;
					var root = "./";
					for (i in 0 ... count) root += "../";
					content += root;

				default:
					// first we will check the metadata for the file, it this name exists.
					if (file.metadata.exists(name)) {
						// [TODO) this will be ugly, need to implement a formotter that looks at options (like for the date)
						content += file.metadata.get(name).toFormat();
						continue;
					}

					// then we check if this is another template that exists
					var subtemp = templates.get(name);
					if (subtemp != null) {
						var sub = new Template(subtemp);
						sub.templates = templates;
						content += sub.apply(file);
						continue;
					}

					warn(Templates.PLUGIN_NAME, c('unknown variable $name'));
			}

		}

		return content;
	}

}
