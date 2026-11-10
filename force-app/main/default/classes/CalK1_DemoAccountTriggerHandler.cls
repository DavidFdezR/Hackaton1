public with sharing class CalK1_DemoAccountTriggerHandler {
    public static void handle(List<CalK1_DemoAccount__c> rows) {
        for (CalK1_DemoAccount__c row : rows) {
            row.Score__c = scoreFor(row.Tier__c);
        }
    }

    public static Decimal scoreFor(String tier) {
        if (tier == 'Gold') {
            return 3;
        }
        if (tier == 'Silver') {
            return 2;
        }
        return 1;
    }
}