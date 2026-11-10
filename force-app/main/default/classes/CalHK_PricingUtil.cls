// S-201 before-state: public applyMargin is called by CalHK_QuoteService.
public with sharing class CalHK_PricingUtil {
    public static Decimal applyMargin(Decimal cost) { return cost == null ? 0 : cost * 1.25; }
}