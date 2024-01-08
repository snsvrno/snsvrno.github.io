package types;

class FileTools {
	public static function get(files : Array<types.File>, fileName : String) : Null<types.File> {
		for (f in files) {
			if (f.fileName == fileName) return f;
		}
		return null;
	}
}

