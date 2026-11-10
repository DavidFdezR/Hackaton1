public with sharing class CalK2_DemoPricingCaller {
    public static Decimal net(Decimal base) {
        return CalK2_DemoPricingService2.listPrice(base);
    }
}