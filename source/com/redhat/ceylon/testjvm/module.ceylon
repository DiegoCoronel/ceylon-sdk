"The `com.redhat.ceylon.testjvm` module contains internal implementation."
native("jvm")
module com.redhat.ceylon.testjvm "1.1.1" {
    import com.redhat.ceylon.test "1.1.1";
    import java.base "7";
    import org.jboss.modules "1.3.3.Final";
    import ceylon.collection "1.1.1";
    import ceylon.file "1.1.1";
    import ceylon.runtime "1.1.1";
}
