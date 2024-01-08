package types;

typedef Options = {
	?area : String,
};

function defaults<A:Options>(child:A) : A {
	var obj : A = cast({ });
	obj = OptionsTools.fillWithValues(obj, child);
	obj = OptionsTools.fillWithValues(obj, cast({
		area : site.Site.options.content_area,
	}));
	return obj;
}

