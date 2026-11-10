public with sharing class CalK4A_DemoInvoiceAuraCtrl {
    @AuraEnabled
    public static Integer countInvoices() {
        return [SELECT COUNT() FROM CalK4A_DemoInvoice__c];
    }
}