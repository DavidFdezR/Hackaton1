public with sharing class CalK4A_DemoErpClient {
    public static HttpResponse ping() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://erp-sandbox.demo.example/ping');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Basic DEMO_PASSWORD_PLACEHOLDER');
        return new Http().send(req);
    }
}