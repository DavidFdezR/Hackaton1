public with sharing class CalK1_DemoAccountCaller4 {
    public static CalK1_DemoAccount__c score(String tier) {
        CalK1_DemoAccount__c row = new CalK1_DemoAccount__c(Name = 'CalK1 caller 4', Tier__c = tier);
        CalK1_DemoAccountTriggerHandler.handle(new List<CalK1_DemoAccount__c>{ row });
        return row;
    }
}