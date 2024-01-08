package markdown;

import site.Site;
import Markdown as Md;

class Markdown {

	private static inline var PLUGIN_NAME:String = "markdown";

	public static function markdown(site:Site, ?options:Options) : Site {
		options = types.OptionsTools.fillWithValues(options, Options.defaults());
		debug(PLUGIN_NAME, c('options: ${options}'), Detailed);

		var area = site.getArea(options.area);
		if (area.length == 0) warn(PLUGIN_NAME, c('area ${options.area} has no items'));
		for (file in area) {
			var debugExtension = '';
			if (options.renderedExtension != null) {
				file.extension = options.renderedExtension;
				debugExtension = " to new extension " + c('${file.extension}');
			}
			debug(PLUGIN_NAME, c('processing ${file.fileName}') + debugExtension);
			file.content = Md.markdownToHtml(file.content);
		}

		return site;
	}
}
