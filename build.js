/// the build script.

const debug = require('metalsmith-debug');

const Metalsmith = require('metalsmith');
const layouts = require('metalsmith-layouts');

// custom stuff.
const ascii = require('./src/ascii');
const git = require('./src/git');

Metalsmith(__dirname)
	.source('./content')
	.destination('./target')

	// removes the git stuff, 
	// so we don't have to worry about it
	.use(git)
	.use(ascii)
	
	.use(layouts())
	
	.use(debug())

	.build(function(err, files) {
		if (err) { throw err; }
	});