import ceylon.collection {
    LinkedList
}
import ceylon.net.http.server {
    EndpointBase
}

shared class Endpoints() {

    value endpoints = LinkedList<EndpointBase>();

    shared void add(EndpointBase endpoint) 
            => endpoints.add(endpoint);

    shared EndpointBase? getEndpointMatchingPath(String requestPath) {
        for (endpoint in endpoints) {
            if (endpoint.path.matches(requestPath)) {
                return endpoint;
            }
        }
        return null;
    }
}
