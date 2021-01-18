// 

const debug = require('debug')('local:sass');

const sass = require('node-sass');

const basename = require('path').basename;
const dirname = require('path').dirname;
const extname = require('path').extname;
const join = require('path').join;
const fs = require('fs');

function main(options) {

	options = options || {};

	return function main(files, metalsmith, callback) {
	
		setImmediate(callback);

		if (options.source == null) throw("can't run without a source path");
		if (options.destination == null) options.destination = "css";
		if (options.includePaths != null) { 
			for (var i in options.includePaths) {
				options.includePaths[i] = metalsmith.path(options.includePaths[i]);
			}
			options.includePaths.push(metalsmith.path(options.source))
		} else {
			options.includePaths = [ metalsmith.path(options.source) ];
		}

		// gets all the files.
		var fullPath = metalsmith.path(options.source);
		var sassFiles = []; 
		fs.readdirSync(fullPath).forEach((file) => {
			if ((extname(file) == ".sass" || extname(file) == ".scss") && basename(file).substr(0,1) != "_") sassFiles.push(join(fullPath, file));
		});
	
		// process the files.
		for (var i in sassFiles) {
			debug('found file: %s',sassFiles[i]);
			var sourcePath = sassFiles[i];
			var destPath = join(metalsmith.path(metalsmith._destination), options.destination, basename(sassFiles[i], extname(sassFiles[i])) + ".css");
			
			var renderedContent = sass.renderSync({
				file: sourcePath,
				includePaths: options.includePaths
			});
			
			if (!fs.existsSync(dirname(destPath))) fs.mkdirSync(dirname(destPath));
			fs.writeFileSync(destPath, renderedContent.css);
		}
	
	}
}

module.exports = main;