public with sharing class CalK4A_DemoInvoiceService_T039 {
    public static Decimal calcTax(Decimal amount, Boolean exempt) {
        return exempt ? 0 : (amount * 0.08).setScale(2);
    }
}