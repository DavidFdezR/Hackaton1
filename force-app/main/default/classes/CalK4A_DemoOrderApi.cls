@RestResource(urlMapping='/calk4a/demoorders/*')
global with sharing class CalK4A_DemoOrderApi {
    @HttpPut
    global static String upsertOrder() {
        return 'ok-put';
    }
}