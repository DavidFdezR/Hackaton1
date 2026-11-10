public with sharing class CalK2_DemoAccountService {
    public static String previewNote(String region) {
        return CalK2_DemoAccountTriggerHandler.defaultNote(region);
    }
}