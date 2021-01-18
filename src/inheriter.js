// takes metadata from parent folders, and applies them to all
// children.

const debug = require('debug')('local:inheriter');

const extname = require('path').extname;
const join = require('path').join;

function popFolder(path) {
	var split = path.split("/");
	if (split.length == 1) split = split[0].split("\\");

	if (split.length > 1) {
		split.pop();
		return split.join("\\");
	} 

	return "";
}

function main(options) {
	options = options || {};

	// adds the default ignores
	if (options.ignoreTags == null) options.ignoreTags = [ ];
	options.ignoreTags.push("title");
	options.ignoreTags.push("draft");
	// the standard stuff that metalsmith makes, that we should
	// ignore.
	options.ignoreTags.push("contents");
	options.ignoreTags.push("stats");
	options.ignoreTags.push("mode");

	return function(files, metalsmith, callback) {

		setImmediate(callback);

		Object.keys(files).forEach((file) => {
			if (extname(file) != ".html") return;
			debug('processing: %s', file);

			var parent = file;
			var lastParent = "";
			while(parent.length > 0 && lastParent != parent) {
				lastParent = parent;
				parent = popFolder(parent);
				
				if (options.parentFiles) {
					options.parentFiles.forEach((pf) => {
						var parentPath = join(parent, pf + ".html");

						if (files[parentPath]) {
							debug('found parent: %s', parentPath);
							var parentFile = files[parentPath];
							
							Object.keys(parentFile).forEach((key) => {
								var use = true;
								options.ignoreTags.forEach((it) => {
									if (it == key) use = false;
								});

								if (use) files[file][key] = parentFile[key];
							});
						}
					});
				}
			}
		});
	}
}

module.exports = main;