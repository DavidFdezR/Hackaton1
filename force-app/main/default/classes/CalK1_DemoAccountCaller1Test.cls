@IsTest
private class CalK1_DemoAccountCaller1Test {
    @IsTest
    static void scoresGold() {
        System.assertEquals(3, CalK1_DemoAccountCaller1.score('Gold').Score__c);
    }
}