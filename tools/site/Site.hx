package site;

import types.File;

class Site {

	inline public static var PLUGIN_NAME:String = 'site';

	public static var options:Options;

	private var areas : Map<String, Array<File>> = new Map();

	/////////////////////////////////////////////////////////////////////
	// chaining functions

	public function new(?options:Options) {
		Site.options = types.OptionsTools.fillWithValues(options, Options.defaults());
		debug(PLUGIN_NAME, c('options: ${Site.options}'), Detailed);
	}

	public function build(?options:BuildOptions) : Site {
		options = types.OptionsTools.fillWithValues(options, BuildOptions.defaults());
		debug(PLUGIN_NAME, c('build options: ${options}'), Detailed);

		if (options.deleteBeforeBuild) files.Files.deleteFolderContents(options.target);
		buildArea(options.area, options.target);
		return this;
	}

	////////////////////////////////////////////////////////////////////
	// for use inside of plugins

	public function getArea(name:String) : Array<File> {
		var area = areas.get(name);
		if (area == null) {
			debug(PLUGIN_NAME, c('creating area $name'), Detailed);
			area = [];
			areas.set(name, area);
		}
		return area;
	}

	////////////////////////////////////////////////////////////////

	private function buildArea(name:String, des:String) {
		var area = getArea(name);
		if (area.length == 0)
			error(PLUGIN_NAME, c('nothing in $name, nothing to build'));

		for (file in area) {
			var fullPath = haxe.io.Path.join([des, file.folder]);
			if (!sys.FileSystem.exists(fullPath)) sys.FileSystem.createDirectory(fullPath);

			var newPath = haxe.io.Path.join([fullPath, file.fileName + "." + file.extension]);
			sys.io.File.saveContent(newPath, file.content);
			debug("build",c('created $newPath'));
		}

	}

}
