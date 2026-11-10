@isTest
private class CalK2_DemoAccountTriggerHandlerTest {
    @isTest
    static void defaultNoteUsesRegion() {
        System.assertEquals('region EMEA', CalK2_DemoAccountTriggerHandler.defaultNote('EMEA'));
    }
}