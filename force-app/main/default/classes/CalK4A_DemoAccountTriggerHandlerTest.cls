@IsTest
private class CalK4A_DemoAccountTriggerHandlerTest {
    @IsTest
    static void defaultsRegion() {
        CalK4A_DemoAccount__c a = new CalK4A_DemoAccount__c(Name = 'Handler demo', Tier__c = 'Gold');
        insert a;
        Assert.areEqual('GLOBAL', [SELECT Region__c FROM CalK4A_DemoAccount__c WHERE Id = :a.Id].Region__c);
    }
}