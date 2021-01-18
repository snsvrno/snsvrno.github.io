/// the build script.

const Metalsmith = require('metalsmith');

const debug = require('metalsmith-debug'); // enables debugging.

const layouts = require('metalsmith-layouts'); // to use template / layout files to generate pages.
const drafts = require('metalsmith-drafts'); // to ignore files unless draft is set as false
const collections = require('metalsmith-collections');
// const tags = require('metalsmith-tags');
// const feed = require('metalsmith-feed'); // for rss feed generation
// const atom = require('metalsmith-feed-atom'); // for atom feed generation

// custom stuff.
const importer = require('./src/importer'); // pulls content from other local sources.
const sass = require('./src/sass'); // processes sass styles
const ascii = require('./src/ascii'); // my adoc parser
const git = require('./src/git'); // hides github files from the processer
const inheriter = require('./src/inheriter'); // allows files to use metadata from other files.

Metalsmith(__dirname)
	.metadata({ 
		title: 'SNSVRNO',
		url: 'https://snsvrno.github.io',
		author: 'snsvrno'
	})

	.source('./content')
	.destination('./target')

	// add additional files to the list
	.use(importer({
		paths: { '../../../games' : 'games' },
		extensions: [ ".adoc" ]
	}))

	// processes files outside of the metalsmith system (like css, images, etc...)
	.use(sass({
		source: "./sass"
	}))

	// removes the git stuff, 
	// so we don't have to worry about it
	.use(git)

	// processes the content, adoc files.
	.use(ascii)
	.use(inheriter({
		// tags to ignore
		ignoreTags: [ "title", "draft" ],

		// files to take the properties from,
		// will take from all files if not defined.
		parentFiles: [ "_" ]

		// if there are tags that are both not arrays, make an arrey
		// and merge them. default behavior is to overwrite.
		// mergeTags: true,

		// if there are tags where one is an array, or one is a map
		// join them. default behavior is to overwrite.
		//joinTags: true
	}))

	.use(layouts())
	
	.use(drafts({
		// all files will be drafts unless specified as not drafts.
		default : true
	}))

	.use(collections())

	//.use(feed({ collection: 'posts' }))
	//.use(atom({ collection: 'posts' }))

	.use(debug())

	.build(function(err, files) {
		if (err) { throw err; }
	});