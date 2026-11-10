public without sharing class CalK4A_DemoInvoiceController {
    @AuraEnabled(cacheable=true)
    public static List<CalK4A_DemoInvoice__c> getInvoices() {
        return [SELECT Id, Name FROM CalK4A_DemoInvoice__c];
    }
}