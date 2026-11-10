@isTest
private class CalK2_DemoAccountServiceTest {
    @isTest
    static void previewAndUpdate() {
        CalK2_DemoAccount__c a = new CalK2_DemoAccount__c(Name = 'Svc');
        insert a;
        a.Demo_Note__c = null;
        update a;
        System.assertEquals('unassigned', [SELECT Demo_Note__c FROM CalK2_DemoAccount__c WHERE Id = :a.Id].Demo_Note__c);
        System.assertEquals('region AMER', CalK2_DemoAccountService.previewNote('AMER'));
    }
}