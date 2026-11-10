@IsTest
private class CalK1_DemoInvoiceServiceTest {
    @IsTest
    static void subtotalSkipsNulls() {
        System.assertEquals(15, CalK1_DemoInvoiceService.subtotal(new List<Decimal>{ 10, null, 5 }));
        System.assertEquals(0, CalK1_DemoInvoiceService.subtotal(null));
    }
    @IsTest
    static void taxIsRoundedToCents() {
        System.assertEquals(1.23, CalK1_DemoInvoiceService.roundTax(1.234));
        System.assertEquals(0, CalK1_DemoInvoiceService.taxFor(null, 5));
    }
    @IsTest
    static void totalAddsTax() {
        System.assertEquals(105, CalK1_DemoInvoiceService.invoiceTotal(new List<Decimal>{ 100 }, 5));
    }
    @IsTest
    static void westIsNotTaxable() {
        System.assertEquals(false, CalK1_DemoInvoiceService.isTaxable('West'));
        System.assertEquals(true, CalK1_DemoInvoiceService.isTaxable('North'));
        System.assertEquals(false, CalK1_DemoInvoiceService.isTaxable(null));
        System.assertEquals('Invoice amount: 5', CalK1_DemoInvoiceService.describe(5));
    }
}