public with sharing class CalK1_DemoReturnCheck {
    public static final Integer RETURN_WINDOW_DAYS = 30;

    public static Boolean isReturnable(Date purchased, Date requested) {
        if (purchased == null || requested == null) {
            return false;
        }
        if (requested < purchased) {
            return false;
        }
        return purchased.daysBetween(requested) <= RETURN_WINDOW_DAYS;
    }

    public static List<Boolean> checkAll(List<Date> purchases, Date requested) {
        List<Boolean> results = new List<Boolean>();
        for (Date purchased : purchases) {
            results.add(isReturnable(purchased, requested));
        }
        return results;
    }
}