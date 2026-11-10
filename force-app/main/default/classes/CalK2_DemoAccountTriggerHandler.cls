public with sharing class CalK2_DemoAccountTriggerHandler {
    public static void handleBefore(List<CalK2_DemoAccount__c> records) {
        for (CalK2_DemoAccount__c r : records) {
            if (String.isBlank(r.Demo_Note__c)) {
                r.Demo_Note__c = defaultNote(r.Region__c);
            }
        }
    }

    public static String defaultNote(String region) {
        return region == null ? 'unassigned' : 'region ' + region;
    }
}