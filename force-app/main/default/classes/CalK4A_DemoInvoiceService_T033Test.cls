@IsTest
private class CalK4A_DemoInvoiceService_T033Test {
    @IsTest
    static void usTax() {
        Assert.areEqual(8.00, CalK4A_DemoInvoiceService_T033.calcTax(100));
    }
}