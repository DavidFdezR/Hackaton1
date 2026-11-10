public with sharing class CalK4B_InvoiceController {
    @AuraEnabled(cacheable=true)
    public static CalK4B_Invoice__c getInvoice(Id recordId) {
        return [SELECT Id, Name, Internal_Note__c FROM CalK4B_Invoice__c WHERE Id = :recordId];
    }
    @AuraEnabled(cacheable=true)
    public static CalK4B_Invoice__c getInvoiceUserMode(Id recordId) {
        return [SELECT Id, Name, Internal_Note__c FROM CalK4B_Invoice__c WHERE Id = :recordId WITH USER_MODE];
    }
    @AuraEnabled(cacheable=true)
    public static List<CalK4B_Invoice__c> listInvoices() {
        return [SELECT Id, Name, Status__c FROM CalK4B_Invoice__c WITH USER_MODE ORDER BY Name LIMIT 50];
    }
}