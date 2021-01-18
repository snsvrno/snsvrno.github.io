// ignores git folders & files

const debug = require('debug')('local:git');

function git(file) {
	return file.length > 3 && file.substr(0,4) == ".git";
}

function main(files, metalsmith, callback) {

	setImmediate(callback);

	Object.keys(files).forEach(function(file) {
		if (!git(file)) { 
			debug('checking file: %s', file);
			return;
		}

		debug('removing file: %s', file);
		delete files[file];
	});
}

module.exports = main;