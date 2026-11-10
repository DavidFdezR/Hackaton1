@isTest
private class CalK2_DemoAccountImportTest {
    @isTest
    static void insertFillsNote() {
        CalK2_DemoAccount__c a = new CalK2_DemoAccount__c(Name = 'Import', Region__c = 'APAC');
        insert a;
        System.assertEquals('region APAC', [SELECT Demo_Note__c FROM CalK2_DemoAccount__c WHERE Id = :a.Id].Demo_Note__c);
    }
}