// gets additional source files from outside the project direction, and imports them
// into the content folder. will also modifiy the original source file with a 'hash'
// so that it can link the two files together when rebuilding / updating if it already
// exists.

const debug = require('debug')('local:importer');

const basename = require('path').basename;
const dirname = require('path').dirname;
const extname = require('path').extname;
const join = require('path').join;
const resolve = require('path').resolve;
const relative = require('path').relative;
const fs = require('fs');

function getAllFiles(path, filterByExtensions) {
	if (!fs.existsSync(path)) return [];

	var files = [];
	
	var contents = fs.readdirSync(path);
	contents.forEach((c) => {
		var fullpath = join(path, c);
		if (fs.statSync(fullpath).isDirectory()) {
			getAllFiles(fullpath, filterByExtensions).forEach((f) => files.push(f));
		} else {
			var add = true;

			if (filterByExtensions != null) {
				add = false;
				var extension = extname(fullpath);
				filterByExtensions.forEach((e) => { if(e == extension) add = true; });
			}

			if (add) files.push(fullpath);
		}
	});

	return files;
}

function main(options) {
	options = options || {};

	return function(files, metalsmith, callback) {

		if (options.paths == null) thrown("need 'paths'");
		if (options.copyToSource == null) options.copyToSource = false;

		for (var path in options.paths) {
			var sourcePath = resolve(metalsmith.path(metalsmith._source), path);
			var destinationBase = options.paths[path];
			if (!fs.existsSync(sourcePath)) debug('ignoring path %s because it doesn\'t exists', sourcePath);

			var importFiles = getAllFiles(sourcePath, options.extensions);
			debug('importing: %s, found %s files', sourcePath, importFiles.length);
			for (var i in importFiles) {
				var file = importFiles[i];

				var newPath = join(destinationBase, relative(sourcePath, file));
				var content = fs.readFileSync(file);

				if (options.copyToSource) {
					// copies the file into the content directory, so if the file disappears then
					// it will still have the content in the site.

					var newSourcePath = join(metalsmith.path(metalsmith._source), newPath);

					if (!fs.existsSync(dirname(newSourcePath))) fs.mkdirSync(dirname(newSourcePath), { recursive: true });
					fs.writeFileSync(newSourcePath, content);
				}

				files[newPath] = {
					contents: content
				};
			}
		}

		callback();

	}
}

module.exports = main;