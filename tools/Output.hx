package;

import ansi.Paint.paint;
import ansi.colors.Style;

enum abstract Level(Int) to Int from Int {
	var All = 0;
	var Basic = 1 << 0;
	var Detailed = 1 << 1;
}

private function getLevelName(level:Level) : String {
	switch(level) {
		case All: return "all";
		case Basic: return "basic";
		case Detailed: return "detailed";
	}
}

class Output {

	private static var colors : Array<ansi.colors.Color>= [
		Blue, Green, Magenta, Cyan
	];

	private static var sources : Array<String> = [];

	// for filtering output
	public static var reg : Null<EReg> = null;
	public static var currentLevel : Level = All;

	public static function warn(source:String, text:String) {
		var formattedSource = paint(' $source ', Black, Yellow, Style.Bold);
		Sys.println('$formattedSource ${ansi.Paint.paintPreserve(text, Yellow, null, Style.FGBright)}');
	}
	public static function error(source:String, text:String) {
		var formattedSource = paint(' $source ', White, Red, Style.Bold);
		Sys.println('$formattedSource ${ansi.Paint.paintPreserve(text, Red, null, Style.FGBright)}');
		Sys.exit(0);
	}

	public static function debug(source:String, text:String, ?level:Level=Basic) {
		if (reg == null) return;
		else if (reg.match(source) && (currentLevel == Level.All || currentLevel & level != 0)) {

			// get the position in the colors array so we can color the source's differently
			// and consistent with each other.
			var pos = {
				var pos = sources.indexOf(source);
				if (pos < 0) {
					sources.push(source);
					pos = sources.length - 1;
				}
				pos;
			}

			var formattedSource = paint(' $source ', Black, colors[pos % colors.length], Style.Bold);
			var levelText = paint(getLevelName(level), colors[pos % colors.length], null, Style.Dim);
			Sys.println('$formattedSource $levelText $text');
		}
	}

}
