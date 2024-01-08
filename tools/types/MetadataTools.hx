package types;

class MetadataTools {

	public static function parse(value:String) : Metadata {
		
		// checking if we have a date. this isn't the best way and we probably
		// need to come up with a better way because there could be other date formats
		// that we might see ...
		if (value.length == 10 && value.charAt(4) == "-" && value.charAt(7) == "-")
			return MDate(Date.fromString(value));

		if (value.toLowerCase() == "true") return MBool(true);
		if (value.toLowerCase() == "false") return MBool(false);

		var float = Std.parseFloat(value);
		if (!Math.isNaN(float)) return MFloat(float);

		var int = Std.parseInt(value);
		if (int != null) return MInt(int);

		return MString(value);
	}

	public static function toFormat(md:Metadata) : String {
		switch (md) {
			case MString(text): return text;
			case MInt(int): return '$int';
			case MFloat(float):
				var accuracy = 10^site.Site.options.float_decimals;
				return '${Math.floor(float/accuracy)*accuracy}';

			case MArray(arr):
				var text = "";
				for (a in arr) text += " " + toFormat(a);
				return text;

			case MBool(b): return if (b) "TRUE" else "FALSE";

			case MDate(date):
				return DateTools.format(date, site.Site.options.date_format);
		}
	}
}
