public with sharing class CalK4A_DemoTaxUtil {
    public static Decimal calcTax(Decimal amount) {
        return (amount * 0.08).setScale(2);
    }
}