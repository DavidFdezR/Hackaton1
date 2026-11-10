public with sharing class CalK4B_InvoiceService {
    public static List<CalK4B_Invoice__c> promoCodes(Set<Id> ids) {
        return [SELECT Id, Promo_Code__c FROM CalK4B_Invoice__c WHERE Id IN :ids WITH USER_MODE];
    }
    public static Integer countByName(String name) {
        return [SELECT COUNT() FROM CalK4B_Invoice__c WHERE Name = :name];
    }
}