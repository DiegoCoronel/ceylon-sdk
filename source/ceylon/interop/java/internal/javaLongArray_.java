package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.LongArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaLongArray_ {
        
    @Ignore
    private javaLongArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;Integer&gt;</code> or
     * <code>Array&lt;java.lang.Long&gt;</code> to a Java 
     * <code>LongArray</code>, that is, to <code>long[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see LongArray
     */
    public static long[] javaLongArray(@Name("array")
    @TypeInfo("ceylon.language::Array<ceylon.language::Integer>|ceylon.language::Array<java.lang::Long>") 
    Object array){
        @SuppressWarnings("rawtypes")
        Object a = ((Array) array).toArray();
        if(a instanceof long[]){
            return (long[]) a;
        }
        throw new AssertionError("Invalid source array type: "+a);
    }

}
