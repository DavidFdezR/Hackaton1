@isTest
private class CalHK_Plant2Test {
    @isTest static void coversRound2() {
        insert new CalHK_Asset__c(Name = 'CalHK Test Asset');
        Test.startTest();
        Database.executeBatch(new CalHK_OnceBatch());
        System.schedule('CalHK Test Schedule', '0 0 2 * * ?', new CalHK_NightlyBatch());
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM CalHK_Asset__c]);
    }
}