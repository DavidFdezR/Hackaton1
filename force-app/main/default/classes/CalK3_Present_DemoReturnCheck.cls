public with sharing class CalK3_Present_DemoReturnCheck {
    public static final Integer RETURN_WINDOW_DAYS = 30;

    public static Boolean isReturnable(Date purchaseDate, Date requestDate) {
        if (purchaseDate == null || requestDate == null || requestDate < purchaseDate) {
            return false;
        }
        return purchaseDate.daysBetween(requestDate) <= RETURN_WINDOW_DAYS;
    }
}