package templates;

class Parser {

	private var cursor:Int = 0;
	private var text:String;

	private function new(text:String) {
		this.text = text;
	}

		public static function parse(text:String) : Array<Token> {
		var tokens : Array<Token> = [ ];
		var p = new Parser(text);

		var t : Null<Token> = null;
		while ( (t = p.nextToken()) != null) tokens.push(t);

		return tokens;
	}

	/////////////////////////////////////////////////////

	private function nextToken() : Null<Token> {
		var char = "";
		var start = cursor;

		while ( (char = text.charAt(cursor++)) != "") switch(char) {
			case "{" if (peakChar() == "{"):
				cursor += 1;
				return Text(text.substring(start, cursor-2));

			case "}" if (peakChar() == "}"):
				if (text.substring(start-2, start) != "{{")
					error(Templates.PLUGIN_NAME, c('error parsing'));

				cursor += 1;
				return Var(text.substring(start, cursor-2));

			default:
		}

		// catches the last one
		if (start+1 != cursor) return Text(text.substring(start, cursor));

		return null;
	}

	private function peakChar(?length:Int=1) : String {
		return text.substring(cursor, cursor+length);
	}

}
