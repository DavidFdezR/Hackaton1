@IsTest
private class CalK1_DemoReturnCheckTest {
    static final Date TODAY_FIXED = Date.newInstance(2026, 11, 10);

    @IsTest
    static void sameDay() {
        System.assert(CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED, TODAY_FIXED));
    }
    @IsTest
    static void withinWindow() {
        System.assertEquals(new List<Boolean>{ true }, CalK1_DemoReturnCheck.checkAll(new List<Date>{ TODAY_FIXED.addDays(-10) }, TODAY_FIXED));
    }
    @IsTest
    static void lastDayOfWindow() {
        System.assert(CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED.addDays(-30), TODAY_FIXED));
    }
    @IsTest
    static void expiredWindow() {
        System.assert(!CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED.addDays(-31), TODAY_FIXED));
    }
    @IsTest
    static void longExpired() {
        System.assert(!CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED.addDays(-60), TODAY_FIXED));
    }
    @IsTest
    static void nullPurchase() {
        System.assert(!CalK1_DemoReturnCheck.isReturnable(null, TODAY_FIXED));
    }
    @IsTest
    static void nullRequest() {
        System.assert(!CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED, null));
    }
    @IsTest
    static void requestBeforePurchase() {
        System.assert(!CalK1_DemoReturnCheck.isReturnable(TODAY_FIXED, TODAY_FIXED.addDays(-1)));
    }
    @IsTest
    static void bulkMaintainsOrder() {
        List<Boolean> results = CalK1_DemoReturnCheck.checkAll(
            new List<Date>{ TODAY_FIXED, TODAY_FIXED.addDays(-31), TODAY_FIXED.addDays(-5) }, TODAY_FIXED);
        System.assertEquals(new List<Boolean>{ true, false, true }, results);
    }
}