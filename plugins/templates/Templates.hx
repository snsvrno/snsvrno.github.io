package templates;

import site.Site;
import types.File;

using types.FileTools;

class Templates {

	inline public static var PLUGIN_NAME:String = "templates";

	public static function template(site:Site, ?options:Options) : Site {
		options = types.OptionsTools.fillWithValues(options, Options.defaults());
		debug(PLUGIN_NAME, c('options: ${options}'), Detailed);

		var tmpls = site.getArea(options.templates);
		if (tmpls.length == 0) warn(PLUGIN_NAME, c('no templates found in ${options.templates}'));

		for (file in site.getArea(options.area)) {
			var templateName : String = switch(file.metadata.get(options.metakey)) {
				case null: null;
				case MString(val): val;
				case var other:
					error(PLUGIN_NAME, c('unexpected metadata type for ${options.metakey}=$other'));
					null;
			};
			if (templateName == null) templateName = options.defaultTemplate;
			var tmpl = tmpls.get(templateName);
			if (tmpl == null) {
				warn(PLUGIN_NAME, c('template $templateName does not exist, skipping processing ${file.fileName}'));
				continue;
			}

			debug(PLUGIN_NAME, c('applying $templateName to ${file.fileName}'), Detailed);
			{
				var tmpl = new Template(tmpl);
				tmpl.templates = tmpls;
				file.content = tmpl.apply(file);
			}
		}

		return site;
	}

	////////////////////////////////////////////////////////////////////////////////////////////

}
