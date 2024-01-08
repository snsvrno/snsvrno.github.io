package types;

class OptionsTools {

	public static function fillWithValues<A>(options : Null<A>, defaultOptions : A) : A {
		if (options == null) return defaultOptions;
		else {
			for (field in Reflect.fields(defaultOptions)) {
				if (!Reflect.hasField(options, field))
					Reflect.setProperty(options, field, Reflect.getProperty(defaultOptions, field));
			}
		}

		return options;
	}

}
