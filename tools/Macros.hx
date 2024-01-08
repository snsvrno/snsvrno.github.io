package;

import haxe.macro.Expr;

class Macros {
	public static macro function color(text:Expr) {
		var regexbase = '^{^\\ ^,^\"';
		var simple = new EReg("\\$(["+regexbase+"]+)","g");
		var complex = new EReg("\\$\\{([^}]+)\\}","g");

		var newtext = "";
		var quotes;

		switch(text.expr) {
			case EConst(CString(string, q)):
				quotes = q;
				newtext = string;
				newtext = complex.map(newtext, regmap);
				newtext = simple.map(newtext, regmap);
			default:
				throw("error");
		}

		text.expr = EConst(CString(newtext, quotes));
		return macro $text;
	}

	private static function regmap(reg:EReg) : String {
		return "${Macros.paint(" + reg.matched(1) +")}";
	}

	public static function paint(thing:Dynamic) : String {

		return switch(Type.typeof(thing)) {
			case TClass(cls) if ('$cls' == "Class<String>"):
				var s = '$thing';
				if (s.charAt(0) == "/" && sys.FileSystem.exists(s))
					ansi.Paint.paint(s, Green, null, ansi.colors.Style.Underline);
				else
					ansi.Paint.paint(s, Green);

			case TClass(cls) if ('$cls' == "Class<Date>"):
				var s = "";
				var d = cast(thing, Date);
				s += paint(d.getFullYear());
				s += ansi.Paint.paint("/", null, null, ansi.colors.Style.Dim);
				s += paint(d.getMonth()+1);
				s += ansi.Paint.paint("/", null, null, ansi.colors.Style.Dim);
				s += paint(d.getDay()+1);
				s;

			case TClass(cls) if ('$cls' == "Class<Array>"):
				var s = ansi.Paint.paint("[ ", null, null, ansi.colors.Style.Dim);
				for (item in cast(thing, Array<Dynamic>)) s += paint(item) + ansi.Paint.paint(", ", null, null, ansi.colors.Style.Dim);
				s + ansi.Paint.paint("]", null, null, ansi.colors.Style.Dim);

			case TClass(cls) if ('$cls' == "Class<haxe.ds.StringMap>"):
				var s = ansi.Paint.paint("[ ", null, null, ansi.colors.Style.Dim);
				for (key => val in cast(thing, Map<String, Dynamic>))
					s += ansi.Paint.paint(key, Yellow) + ansi.Paint.paint(":", null, null, ansi.colors.Style.Dim)
						+ paint(val) +  ansi.Paint.paint(", ", null, null, ansi.colors.Style.Dim);
				s + ansi.Paint.paint("]", null, null, ansi.colors.Style.Dim);

			case TEnum(cls) if ('$cls' == "Enum<types.Metadata>"):
				switch(cast(thing, types.Metadata)) {
					case MInt(v): paint(v);
					case MString(v): paint(v);
					case MFloat(v): paint(v);
					case MBool(v): paint(v);
					case MDate(v): paint(v);
					case MArray(arr):
						var s = ansi.Paint.paint("[ ", null, null, ansi.colors.Style.Dim);
						for (a in arr)
							s += paint(a) + ansi.Paint.paint(", ", null, null, ansi.colors.Style.Dim);
						s + ansi.Paint.paint("]", null, null, ansi.colors.Style.Dim);
				}

			case TObject:
				var s = ansi.Paint.paint("{ ", null, null, ansi.colors.Style.Dim);

				var keys = Reflect.fields(thing);
				for (key in keys)
					s += ansi.Paint.paint(key, Cyan)
						+ ansi.Paint.paint(":", null, null, ansi.colors.Style.Dim)
						+ paint(Reflect.getProperty(thing, key)) 
						+ ansi.Paint.paint(", ", null, null, ansi.colors.Style.Dim);

				s + ansi.Paint.paint("}", null, null, ansi.colors.Style.Dim);

			case TInt:
				ansi.Paint.paint('$thing', Blue);

			case TBool:
				ansi.Paint.paint('$thing', Magenta);

			case var unknown:
				trace('unknown class for paint: $unknown');
				'$thing';
		}
	}
}
