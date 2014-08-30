import ceylon.time {
    Date,
    date,
    time,
	DateTime
}
import ceylon.time.base {
    years,
    december
}

shared ZoneUntil untilPresent = ZoneUntil(date(years.maximum, december, 31), AtWallClockTime(time(23,59,59,999)));

"To represent a [[ZoneTimeline]] that continues until the present you should 
 use [[untilPresent]]"
shared class ZoneUntil(date, ruleDefinition) {
    Date date;
    AtTime ruleDefinition;
    
    shared DateTime dateTime {
        return date.at(ruleDefinition.time);
    }
    
    shared actual Boolean equals(Object other) {
        if(is ZoneUntil other) {
            return date == other.date
                && ruleDefinition == other.ruleDefinition;
        }
        return false;
    }
}