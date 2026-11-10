public with sharing class CalK5_DemoInvoiceService {
    public static Decimal withTax(Decimal net) {
        return net * 1.1;
    }
}