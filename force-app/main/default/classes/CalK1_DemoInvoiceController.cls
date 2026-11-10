public with sharing class CalK1_DemoInvoiceController {
    @AuraEnabled(cacheable=true)
    public static List<CalK1_DemoInvoice__c> getMyOpenInvoices() {
        return [SELECT Id, Name, Region__c, Amount__c FROM CalK1_DemoInvoice__c WHERE Open__c = true LIMIT 200];
    }
}