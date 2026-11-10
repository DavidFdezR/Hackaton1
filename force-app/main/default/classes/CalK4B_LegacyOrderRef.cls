public with sharing class CalK4B_LegacyOrderRef {
    public static Integer countOrders() {
        return [SELECT COUNT() FROM CalK4B_LegacyOrder__c];
    }
}