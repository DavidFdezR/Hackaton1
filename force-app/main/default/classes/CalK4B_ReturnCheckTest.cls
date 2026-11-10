@IsTest
private class CalK4B_ReturnCheckTest {
    private static CalK4B_ReturnCheck.Request request(Integer days, Boolean unopened) {
        CalK4B_ReturnCheck.Request value = new CalK4B_ReturnCheck.Request();
        value.daysSinceDelivery = days;
        value.unopened = unopened;
        return value;
    }
    private static void check(Integer days, Boolean unopened, String decision, String reason) {
        List<CalK4B_ReturnCheck.Result> results = CalK4B_ReturnCheck.evaluate(
            new List<CalK4B_ReturnCheck.Request>{request(days, unopened)});
        System.assertEquals(1, results.size());
        System.assertEquals(decision, results[0].decision);
        System.assertEquals(reason, results[0].reasonCode);
    }
    @IsTest static void eligibleDayZero() {
        check(0, true, 'ELIGIBLE', 'WITHIN_WINDOW_AND_UNOPENED');
    }
    @IsTest static void eligibleBoundary() {
        check(30, true, 'ELIGIBLE', 'WITHIN_WINDOW_AND_UNOPENED');
    }
    @IsTest static void expiredWindow() {
        check(31, true, 'NOT_ELIGIBLE', 'OUTSIDE_RETURN_WINDOW');
    }
    @IsTest static void openedItem() {
        check(10, false, 'NOT_ELIGIBLE', 'ITEM_OPENED');
    }
    @IsTest static void missingDays() {
        check(null, true, 'REVIEW', 'MISSING_INFORMATION');
    }
    @IsTest static void missingCondition() {
        check(10, null, 'REVIEW', 'MISSING_INFORMATION');
    }
    @IsTest static void negativeDays() {
        check(-1, true, 'REVIEW', 'INVALID_DELIVERY_AGE');
    }
    @IsTest static void bulkMaintainsOrder() {
        List<CalK4B_ReturnCheck.Request> inputs = new List<CalK4B_ReturnCheck.Request>();
        for (Integer i = 0; i < 200; i++) {
            inputs.add(request(i, true));
        }
        Integer queries = Limits.getQueries();
        Integer writes = Limits.getDmlStatements();
        Integer callouts = Limits.getCallouts();
        List<CalK4B_ReturnCheck.Result> results = CalK4B_ReturnCheck.evaluate(inputs);
        System.assertEquals(200, results.size());
        for (Integer i = 0; i < 200; i++) {
            System.assertEquals(i <= 30 ? 'ELIGIBLE' : 'NOT_ELIGIBLE', results[i].decision);
            System.assertEquals(i <= 30 ? 'WITHIN_WINDOW_AND_UNOPENED' : 'OUTSIDE_RETURN_WINDOW', results[i].reasonCode);
        }
        System.assertEquals(queries, Limits.getQueries());
        System.assertEquals(writes, Limits.getDmlStatements());
        System.assertEquals(callouts, Limits.getCallouts());
    }
    @IsTest static void nullRequestAndBatch() {
        System.assertEquals(0, CalK4B_ReturnCheck.evaluate(null).size());
        System.assertEquals(0, CalK4B_ReturnCheck.evaluate(new List<CalK4B_ReturnCheck.Request>()).size());
        List<CalK4B_ReturnCheck.Result> results = CalK4B_ReturnCheck.evaluate(
            new List<CalK4B_ReturnCheck.Request>{null});
        System.assertEquals(1, results.size());
        System.assertEquals('REVIEW', results[0].decision);
        System.assertEquals('MISSING_INFORMATION', results[0].reasonCode);
    }
}