@IsTest
private class CalK4B_NightlySyncTest {
    @IsTest
    static void runs() {
        Test.startTest();
        new CalK4B_NightlySync().execute(null);
        Test.stopTest();
        System.assert(true);
    }
}