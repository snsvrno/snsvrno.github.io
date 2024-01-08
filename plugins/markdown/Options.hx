package markdown;

typedef Options = {
	> types.Options,
	?renderedExtension : String
};

function defaults() : Options {
	return types.Options.defaults({
	});
}


