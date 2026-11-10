// T-210: without sharing, trusts the caller's record Id (IDOR if exposed to guests).
public without sharing class CalHK_PublicController {
    @AuraEnabled(cacheable=true)
    public static CalHK_Order__c getRecord(Id recordId) { return [SELECT Id, Name, Status__c FROM CalHK_Order__c WHERE Id = :recordId]; }
}