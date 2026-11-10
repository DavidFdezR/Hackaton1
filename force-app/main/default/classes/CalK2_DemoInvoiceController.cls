public with sharing class CalK2_DemoInvoiceController {
    @AuraEnabled(cacheable=true)
    public static CalK2_DemoInvoice__c getInvoice(Id invoiceId) {
        List<CalK2_DemoInvoice__c> rows = [SELECT Id, Name, Amount__c FROM CalK2_DemoInvoice__c WHERE Id = :invoiceId];
        if (rows.isEmpty()) {
            throw new AuraHandledException('record not found');
        }
        return rows[0];
    }
}