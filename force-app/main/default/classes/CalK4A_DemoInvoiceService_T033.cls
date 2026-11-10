public with sharing class CalK4A_DemoInvoiceService_T033 {
    public static Decimal calcTax(Decimal amount) {
        return calcTax(amount, 'US');
    }

    public static Decimal calcTax(Decimal amount, String region) {
        Decimal rate = region == 'EU' ? 0.20 : 0.08;
        return (amount * rate).setScale(2);
    }
}