@IsTest
private class CalK5_DemoInvoiceServiceTest {
    @IsTest
    static void addsTenPercentTax() {
        Assert.areEqual(120, CalK5_DemoInvoiceService.withTax(100), 'deliberately failing fixture for A-002');
    }
}