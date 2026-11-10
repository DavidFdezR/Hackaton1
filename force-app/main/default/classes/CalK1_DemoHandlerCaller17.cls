public with sharing class CalK1_DemoHandlerCaller17 {
    public static Decimal score(String tier) {
        CalK1_DemoAccount__c row = new CalK1_DemoAccount__c(Name = 'CalK1 handler caller 17', Tier__c = tier);
        CalK1_DemoAccountTriggerHandler.handle(new List<CalK1_DemoAccount__c>{ row });
        return row.Score__c;
    }
}