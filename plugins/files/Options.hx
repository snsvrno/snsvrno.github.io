package files;

typedef Options = {
	> types.Options,
	?path : String,
	?extension : String,
	?extensions : Array<String>,
};

function defaults() : Options {
	return types.Options.defaults({
		path: "content",
	});
}


