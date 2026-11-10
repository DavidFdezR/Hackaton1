@IsTest
private class CalK1_DemoAccountCaller6Test {
    @IsTest
    static void scoresGold() {
        System.assertEquals(3, CalK1_DemoAccountCaller6.score('Gold').Score__c);
    }
}