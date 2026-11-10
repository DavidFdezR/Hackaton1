public with sharing class CalHK_QuoteService {
    public static Decimal quote(Decimal cost) { return CalHK_PricingUtil.applyMargin(cost); }
}