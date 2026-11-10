@IsTest
private class CalK4A_RoundLine_T038Test {
    @IsTest
    static void roundsHalfUp() {
        Assert.areEqual(1.01, CalK4A_DemoInvoiceService_T038.roundLine(1.005));
        Assert.areEqual(2.02, CalK4A_DemoInvoiceService_T038.lineTotal(2, 1.01));
    }
}