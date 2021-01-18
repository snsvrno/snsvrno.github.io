// converts adoc files to html with metadata.

const asciidoctor = require('asciidoctor.js')();
const trim = require('./trim');

const debug = require('debug')('local:ascii');

const basename = require('path').basename;
const dirname = require('path').dirname;
const extname = require('path').extname;
const join = require('path').join;

function splitByLine(text) {
	var lines = text.split("\n");
	return lines;
}

function parseMetadata(text) {
	var meta = { };

	text = text.substr(1);
	var i = text.search(":");

	meta.key = trim(text.substr(0,i));
	meta.value = trim(text.substr(i+1));

	// a list
	if (meta.value.search(";") > 0) meta.value = meta.value.split(";");

	return meta;
}

function extractMetadata(text) {
	var metadata = { };

	var split = splitByLine(text);
	for (var i in split) {
		var line = split[i];

		// title
		if (line.substr(0,1) == "=" && line.substr(0,2) != "==") metadata["title"] = trim(line.substr(1));
		
		// a `:xxx:` yyyyy metadata line
		else if (line.substr(0,1) == ":") {
			var set = parseMetadata(line);
			metadata[set.key] = set.value;
		}

		// the next title, == asdasd, which is the end of the metadata section.
		else if (line.substr(0,2) == "==") break;
	}

	return metadata;

}

function adoc(file) {
	return /\.adoc$|\.asciidoc$/.test(extname(file));
};

function plugin(files, metalsmith, callback) {
	setImmediate(callback);

	Object.keys(files).forEach(function(file) {
		if (!adoc(file)) {	
			debug('checking file: %s', file);
			return;
		}

		var data = files[file];
		var dir = dirname(file);
		var html = basename(file, extname(file)) + '.html';

		if ('.' != dir) html = join(dir, html);

		debug('converting file: %s', file);

		// first we extract the metadata.
		var metadata = extractMetadata(data.contents.toString())
		Object.keys(metadata).forEach(function(key) {
			debug('setting key: %s => %s', key, metadata[key]);
			data[key] = metadata[key];
		});

		// then we convert it into an html file.
		var newContent = asciidoctor.convert(data.contents.toString());
		try { data.contents = Buffer.from(newContent); } 
		catch (err) { data.contents = new Buffer(newContent); }

		delete files[file];
		files[html] = data;
	});
}

module.exports = plugin;