package templates;

typedef Options = {
	> types.Options,
	?templates : String,
	?metakey : String,
	?defaultTemplate : String,
};

function defaults() : Options {
	return types.Options.defaults({
		templates : "templates",
		metakey : "template",
		defaultTemplate : "template",
	});
}


