@IsTest
private class CalK4A_DemoInvoiceService_T037Test {
    @IsTest
    static void tax() {
        Assert.areEqual(8.00, CalK4A_DemoInvoiceService_T037.calcTax(100));
        Assert.areEqual(0.80, CalK4A_DemoInvoiceService_T037.calcTax(10));
    }
}