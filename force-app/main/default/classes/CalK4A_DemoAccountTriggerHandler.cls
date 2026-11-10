public with sharing class CalK4A_DemoAccountTriggerHandler {
    public static final String DEFAULT_REGION = 'GLOBAL';

    public static void beforeSave(List<CalK4A_DemoAccount__c> rows) {
        for (CalK4A_DemoAccount__c row : rows) {
            if (String.isBlank(row.Region__c)) {
                row.Region__c = DEFAULT_REGION;
            }
        }
    }
}