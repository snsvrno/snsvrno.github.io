/// the trim function

const defaultCharacters = [ "\n", "\r", "\t", " " ];

function trim(text, characters) {
	if (characters == null) characters = defaultCharacters;
	
	var found = true;
	// trims the front
	while(found) {
		found = false;

		for (var i in characters) {
			if (text.substr(0,1) == characters[i]) found = true;
		}

		if (found) text = text.substr(1);
	}
	
	found = true
	// trims the back
	while(found) {
		found = false;

		for (var i in characters) {
			if (text.substr(text.length-1) == characters[i]) found = true;
		}

		if (found) text = text.substr(0, text.length-1);
	}

	return text;
}

module.exports = trim;