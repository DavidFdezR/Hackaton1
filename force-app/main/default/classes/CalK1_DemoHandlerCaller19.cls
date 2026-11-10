public with sharing class CalK1_DemoHandlerCaller19 {
    public static Decimal score(String tier) {
        CalK1_DemoAccount__c row = new CalK1_DemoAccount__c(Name = 'CalK1 handler caller 19', Tier__c = tier);
        CalK1_DemoAccountTriggerHandler.handle(new List<CalK1_DemoAccount__c>{ row });
        return row.Score__c;
    }
}