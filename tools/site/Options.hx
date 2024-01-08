package site;

typedef Options = {
	?content_area: String,
	?target_folder: String,
	?float_decimals: Int,
	?date_format: String,
};

function defaults () : Options {
	return {
		content_area: "content",
		target_folder: "target",
		date_format: "",
		float_decimals: 2,
	};
}
