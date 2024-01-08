package site;

typedef BuildOptions = {
	?area : String,
	?target : String,
	?deleteBeforeBuild : Bool,
};

function defaults () : BuildOptions {
	return {
		area : Site.options.content_area,
		target : Site.options.target_folder,
		deleteBeforeBuild : false,
	};
}
