// T-? / S-? before-state: with sharing + WITH USER_MODE (the control the risky fix would remove).
public with sharing class CalHK_InvoiceSelector {
    public static List<CalHK_Invoice__c> getInvoices() {
        return [SELECT Id, Name, Amount__c, Discount__c FROM CalHK_Invoice__c WITH USER_MODE LIMIT 200];
    }
}