@IsTest
private class CalK1_DemoAccountTriggerHandlerTest {
    @IsTest
    static void goldScoresThreeOnInsert() {
        CalK1_DemoAccount__c row = new CalK1_DemoAccount__c(Name = 'CalK1 handler test', Tier__c = 'Gold');
        insert row;
        row = [SELECT Score__c FROM CalK1_DemoAccount__c WHERE Id = :row.Id];
        System.assertEquals(3, row.Score__c);
    }

    @IsTest
    static void everyTierGetsAScore() {
        for (String tier : new List<String>{ 'Gold', 'Silver', 'Bronze', null }) {
            System.assert(CalK1_DemoAccountTriggerHandler.scoreFor(tier) >= 0);
        }
    }
}