public with sharing class CalK4A_DemoInvoiceService_T038 {
    public static Decimal lineTotal(Decimal qty, Decimal price) {
        return roundLine(qty * price);
    }

    public static Decimal roundLine(Decimal value) {
        return value.setScale(2, System.RoundingMode.HALF_UP);
    }
}