@IsTest
private class CalK3_Present_DemoReturnCheckTest {
    @IsTest
    static void withinWindowIsReturnable() {
        Date bought = Date.newInstance(2026, 1, 1);
        Assert.isTrue(CalK3_Present_DemoReturnCheck.isReturnable(bought, bought.addDays(30)));
    }

    @IsTest
    static void pastWindowIsNotReturnable() {
        Date bought = Date.newInstance(2026, 1, 1);
        Assert.isFalse(CalK3_Present_DemoReturnCheck.isReturnable(bought, bought.addDays(31)));
    }

    @IsTest
    static void invalidDatesAreNotReturnable() {
        Date bought = Date.newInstance(2026, 1, 1);
        Assert.isFalse(CalK3_Present_DemoReturnCheck.isReturnable(null, bought));
        Assert.isFalse(CalK3_Present_DemoReturnCheck.isReturnable(bought, bought.addDays(-1)));
    }
}