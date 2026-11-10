public with sharing class CalK4B_RegionReader {
    public static String regionOf(Id accountId) {
        return [SELECT Region__c FROM CalK4B_Account__c WHERE Id = :accountId].Region__c;
    }
}