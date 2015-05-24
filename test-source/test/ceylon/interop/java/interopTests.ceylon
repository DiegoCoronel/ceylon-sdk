import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    ...
}
import ceylon.test {
    assertFalse,
    assertEquals,
    test,
    assertTrue,
    assertNull
}

import java.lang {
    System {
        getSystemProperty=getProperty
    },
    JString=String
}
import java.util {
    ArrayList,
    HashSet,
    LinkedHashSet,
    TreeSet,
    LinkedList,
    Date
}

test void stringTests() {
    value val = javaString(getSystemProperty("user.home"));
    assertFalse(val.empty);
}

test void collectionTests() {
    value lst = ArrayList<Integer>(JavaCollection([ 1, 2, 3 ]));
    
    value iter = CeylonIterator(lst.iterator());
    variable value val = 1;
    while (!is Finished i=iter.next()) {
        assertEquals(val++, i);
    }
    
    val = 1;
    for (Integer i in CeylonIterable(lst)) {
        assertEquals(val++, i);
    }
}

test void bug264() {
    HashSet<Date>().addAll(JavaCollection<Date>([]));
    LinkedHashSet<Date>().addAll(JavaCollection<Date>([]));
    TreeSet<Date>().addAll(JavaCollection<Date>([]));
    ArrayList<Date>().addAll(JavaCollection<Date>([]));
    LinkedList<Date>().addAll(JavaCollection<Date>([]));
}

test void classTests() {
    Integer x = 5;
    value klass1 = javaClassFromInstance(x);
    assertEquals("class ceylon.language.Integer", klass1.string);
    
    value klass2 = javaClass<String>();
    assertEquals("class ceylon.language.String", klass2.string);
}

test void ceylonStringMap() {
    value jsMap = HashMap { javaString("one") -> 1, javaString("two") -> 2 };
    value csMap = CeylonStringMap(jsMap);

    assertEquals(csMap.get("one"), 1);
    assertEquals(csMap.get("two"), 2);
    assertTrue(csMap.defines("one"));
    assertFalse(csMap.defines(javaString("one")));
    assertFalse(csMap.defines("ONE"));
    assertTrue(csMap.keys.contains("two"));
    assertEquals(csMap.keys.size, 2);
    assertEquals(CeylonStringMap(emptyMap).size, 0);
}

test void ceylonStringMutableMap() {
    value jsMap = HashMap { javaString("one") -> 1 };
    value csMap = CeylonStringMutableMap(jsMap);
    csMap.put("two", 2);

    assertEquals(jsMap.get(javaString("two")), 2);

    assertEquals(csMap.get("one"), 1);
    assertEquals(csMap.get("two"), 2);
    assertTrue(csMap.defines("one"));
    assertFalse(csMap.defines(javaString("one")));
    assertFalse(csMap.defines("ONE"));
    assertTrue(csMap.keys.contains("two"));
    assertEquals(csMap.keys.size, 2);
    assertEquals(CeylonStringMutableMap(
        HashMap<JString, Object>()).size, 0);

    csMap.remove("two");
    assertNull(jsMap.get(javaString("two")));
}
