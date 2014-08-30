import ceylon.language { sys = system }
import ceylon.time { Instant }
import ceylon.time.base { ms = milliseconds }
import ceylon.collection {
	MutableMap,
	HashMap
}
import ceylon.time.timezone.parser {
	parseZoneLine,
	parseLinkLine,
	parseRuleLine
}
import ceylon.time.timezone.model {
	Zone
}

"The interface representing a timezone."
shared interface TimeZone of OffsetTimeZone | RuleBasedTimezone {

    "Returns offset in milliseconds of the specified instant according to this time zone."
    shared formal Integer offset(Instant instant);

}

"A simple time zone with a constant offset from UTC."
shared class OffsetTimeZone(offsetMilliseconds) satisfies TimeZone {

    "The value that represents this constant offset in milliseconds."
    shared Integer offsetMilliseconds;

    "Always returns a constant offset."
    shared actual Integer offset(Instant instant) => offsetMilliseconds;

    "Returns _true_ if given value is same type and offset milliseconds."
    shared actual Boolean equals( Object other ) {
        if ( is OffsetTimeZone other ) {
            return this.offsetMilliseconds == other.offsetMilliseconds;
        }
        return false;
    }

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        value prime = 31;
        value result = 7;
        return prime * result + offsetMilliseconds.hash;
    }

    "Returns ISO-8601 formatted String representation of this _time of day_.\n
     https://en.wikipedia.org/wiki/ISO_8601#Time_offsets_from_UTC"
    shared default actual String string {
        value offsetHours = ((offsetMilliseconds.magnitude / ms.perHour)).string.padLeading(2, '0');
        value offsetMinutes = ((offsetMilliseconds.magnitude % ms.perHour) / ms.perMinute).string.padLeading(2, '0');

        if (offsetMilliseconds >= 0) {
            return "+``offsetHours``:``offsetMinutes``";
        }
        else {
            return "-``offsetHours``:``offsetMinutes``";
        }
    }

}

"This represents offsets based on daylight saving time."
shared interface RuleBasedTimezone satisfies TimeZone {
    //TODO: Implement complex rule based time zones
}

"Common utility methods for getting time zone instances."
shared object timeZone {

    "Current system time zone."
    shared object system extends OffsetTimeZone(sys.timezoneOffset) {}

    "Coordinated Universal Time (UTC) time zone."
    shared object utc extends OffsetTimeZone(0) {
        "Returns ISO-8601 formatted String representation of this _time of day_.\n
         https://en.wikipedia.org/wiki/ISO_8601#Time_offsets_from_UTC"
        shared actual String string  = "Z";
    }

    "Parses input string and returns appropriate time zone.
     Currently it accepts only ISO-8601 time zone offset patterns:
     &plusmn;`[hh]:[mm]`, &plusmn;`[hh][mm]`, and &plusmn;`[hh]`.

     In addition, the special code `Z` is recognized as a shorthand for `+00:00`."
    shared TimeZone|ParserError parse(String zone) {
        return parseTimeZone(zone);
    }

    "Represents fixed timeZone created based on given values."
    shared OffsetTimeZone offset(Integer hours, Integer minutes = 0, Integer milliseconds = 0) {
        value offsetMilliseconds = hours * ms.perHour + minutes * ms.perMinute + milliseconds;
        assert (-12 * ms.perHour <= offsetMilliseconds <= 12 * ms.perHour);
        if (offsetMilliseconds == 0) {
            return utc;
        }
        return OffsetTimeZone( offsetMilliseconds );
    }

}

object provider {
	
	[String*] supportedDatabases = ["africa", "antarctica", "asia", "australasia", "backward",
	"etcetera", "europe", "northamerica", "southamerica"];
	
	MutableMap<String, Zone> zones = HashMap<String, Zone>();
	
	shared void load() {
		for (database in supportedDatabases) {
			value resource = `module ceylon.time`.resourceByPath("``database``");
			if (exists resource) {
				for (rawLine in resource.textContent().lines) {
					if (rawLine.startsWith("#")) { continue; }
					value line = cleanLine(rawLine); 
					
					if(line.startsWith("Zone")) {
						value zoneTimeline = parseZoneLine(line);
					} else if(line.startsWith("Link")) {
						value link = parseLinkLine(line);
					} else if(line.startsWith("Rule")) {
						value rule = parseRuleLine(line);
					} else {
						value zoneTimeline = parseZoneLine(line, "");
					}
				}
			}
		}
	}
	
	String cleanLine(String rawLine) {
		String line;
		if(exists index = rawLine.firstOccurrence('#')) {
			line = rawLine.spanTo(index-1).trimmed;
		} else {
			line = rawLine.trimmed;
		}
		return line;
	}
	
}
