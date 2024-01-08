package frontmatter;

typedef Options = {
	> types.Options,
	?seperator : String,
};

function defaults() : Options {
	return types.Options.defaults({
		seperator : "---",
	});
}


