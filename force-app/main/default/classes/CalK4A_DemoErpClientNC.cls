public with sharing class CalK4A_DemoErpClientNC {
    public static HttpResponse ping() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:CalK4A_DemoERP_NC/ping');
        req.setMethod('GET');
        return new Http().send(req);
    }
}