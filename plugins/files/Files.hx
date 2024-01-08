package files;

import site.Site;
import types.File;

class Files {

	private static var PLUGIN_NAME:String = "file";

	public static function addFiles(site : Site, ?options : Options) : Site {
		options = types.OptionsTools.fillWithValues(options, Options.defaults());
		debug(PLUGIN_NAME, c('options: ${options}'), Detailed);

		if (options.extensions == null && options.extension == null)
			error(PLUGIN_NAME, c('need to define either $"extensions" or $"extension" on we know what files to add'));

		var extensions = if (options.extensions != null && options.extensions.length > 0) 
			options.extensions
		else [ options.extension ];

		var fullPath = sys.FileSystem.absolutePath(options.path);
		if (!sys.FileSystem.exists(fullPath))
			error(PLUGIN_NAME, c('path $fullPath does not exist'));

		debug(PLUGIN_NAME, c('scanning $fullPath, adding to area ${options.area}'));

		var area = site.getArea(options.area);

		var startcount = area.length;
		for (file in scan(fullPath, extensions)) {
			area.push(file);
		}
		debug(PLUGIN_NAME, c('added ${area.length - startcount} files'));


		return site;
	}

	////////////////////////////////////////////////////////////////////////////

	private static var ignoreFolders = [ '.git', ];

	private static function scan(path:String, extensions:Array<String>, ?root:String) : Array<File> {
		var files = [];

		if (root != null && path.substring(0,root.length) != root)
			error(PLUGIN_NAME, c('error with root path in scan: $path, $extensions, $root'));

		if (root == null) root = path;

		for (entry in sys.FileSystem.readDirectory(path)) {
			var fullPath = haxe.io.Path.join([path, entry]);
	
			switch (sys.FileSystem.isDirectory(fullPath)) {
				case true:
					if (ignoreFolders.contains(entry)) {
						debug(PLUGIN_NAME, c('skipping $fullPath'), Detailed);
						continue;
					}

					for (i in scan(fullPath, extensions, root))
						files.push(i);

				case false:
					if (extensions.contains(haxe.io.Path.extension(entry))) {
						debug(PLUGIN_NAME,c('adding ${fullPath}'), Detailed);
						files.push({
							folder : path.substring(root.length),
							fileName : haxe.io.Path.withoutExtension(entry),
							extension : haxe.io.Path.extension(entry).toLowerCase(),
							content : sys.io.File.getContent(fullPath),
							metadata: new Map(),
						});
					}
			}
		}


		return files;
	}

	public static function deleteFolderContents(path:String) {
		var files = simpleScan(path, false);
		files.sort((a,b) -> {
			if (a.length > b.length) return 1;
			else return -1;
		});

		while(files.length > 0) {
			var f = files.pop();
			debug(PLUGIN_NAME, c('deleting $f'), Detailed);
			if (sys.FileSystem.isDirectory(f)) sys.FileSystem.deleteDirectory(f);
			else sys.FileSystem.deleteFile(f);
		}
	}

	private static function simpleScan(path : String, ?includeRoot : Bool = true) : Array<String> {

		var files = if (includeRoot) [path] else [ ];

		for (entry in sys.FileSystem.readDirectory(path)) {
			var fullPath = haxe.io.Path.join([path, entry]);

			if (sys.FileSystem.isDirectory(fullPath)) {
				// to not delete a git repo
				if (entry == '.git') continue;

				for (i in simpleScan(fullPath)) files.push(i);

			} else {
				// to not delete a git stuff
				if (entry == '.gitignore') continue;

				files.push(fullPath);
			}

		}
		return files;
	}

}
