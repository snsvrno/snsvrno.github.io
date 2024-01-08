package types;

enum Metadata {
	MDate(_:Date);
	MBool(_:Bool);
	MString(_:String);
	MInt(_:Int);
	MFloat(_:Float);
	MArray(_:Array<Metadata>);
}
