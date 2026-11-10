// T-110: without sharing controller; granting class access to a permission set exposes every contract.
public without sharing class CalHK_AdminTools {
    @AuraEnabled(cacheable=true)
    public static List<CalHK_Contract__c> getAllContracts() { return [SELECT Id, Name, Amount__c FROM CalHK_Contract__c LIMIT 500]; }
}