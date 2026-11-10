public with sharing class CalR_DemoAccountTriggerHandler {
    public static final Decimal LARGE_DEAL_THRESHOLD = 100000;

    public static String classify(Decimal amount) {
        if (amount == null) {
            return 'Unknown';
        }
        return amount >= LARGE_DEAL_THRESHOLD ? 'Large' : 'Small';
    }

    public static void beforeSave(List<CalR_DemoAccount__c> accounts) {
        for (CalR_DemoAccount__c account : accounts) {
            account.Tier__c = classify(account.Amount__c);
        }
    }
}