@IsTest
private class CalK1_DemoAccountCaller2Test {
    @IsTest
    static void scoresSilver() {
        System.assertEquals(2, CalK1_DemoAccountCaller2.score('Silver').Score__c);
    }
}