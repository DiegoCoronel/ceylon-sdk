import ceylon.io.buffer {
    ByteBuffer,
    CharacterBuffer
}

"Represents the ISO 8859-1 character set as defined by the 
 [specification](http://www.iso.org/iso/catalogue_detail?csnumber=28245)."
by("Stéphane Épardaud")
shared object iso_8859_1 satisfies Charset {
    
    "Returns `ISO-8859-1`. This deviates a bit from 
     [the internet registry][] which defines it as
     `ISO_8859-1:1987`, whereas we use its _preferred MIME 
     name_ because that is more widely known.
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String name = "ISO-8859-1";

    "The set of aliases, as defined by 
     [the internet registry][]. Note that because we use the 
     _preferred MIME name_ (`ISO-8859-1`) as [[name]], we 
     include the official character set name `ISO_8859-1:1987` 
     in the aliases, thereby deviating from the spec.
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String[] aliases = [
        "ISO_8859-1:1987", // official name
        "iso-ir-100",
        "ISO_8859-1",
        "latin1",
        "l1",
        "IBM819",
        "CP819",
        "csISOLatin1",
        // idiot-proof aliases
        "iso-8859_1", 
        "iso_8859_1", 
        "iso8859-1", 
        "iso8859_1", 
        "latin-1", 
        "latin_1"
    ];

    "Returns 1."
    shared actual Integer minimumBytesPerCharacter => 1;

    "Returns 1."
    shared actual Integer maximumBytesPerCharacter => 1;
    
    "Returns 1."
    shared actual Integer averageBytesPerCharacter => 1;

    shared actual class Encoder() 
            extends super.Encoder() {
        
        shared actual void encode(CharacterBuffer input, ByteBuffer output) {
            // give up if there's no input or no room for output
            while(input.hasAvailable && output.hasAvailable) {
                value char = input.get().integer;
                if(char > 255) {
                    // FIXME: type
                    throw Exception("Invalid ISO_8859-1 byte value: `` char ``");
                }
                output.putByte(char.byte);
            }
        } 
    }
    
    shared actual class Decoder() 
            extends super.Decoder()  {
        
        value builder = StringBuilder();
        
        shared actual void decode(ByteBuffer buffer) {
            for(byte in buffer) {
                builder.appendCharacter(byte.unsigned.character);
            }
        }
        
        shared actual String consume() {
            value result = builder.string;
            builder.clear();
            return result;
        }
    }
}

