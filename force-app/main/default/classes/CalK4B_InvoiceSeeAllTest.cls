@IsTest(SeeAllData=true)
private class CalK4B_InvoiceSeeAllTest {
    @IsTest
    static void findsSeedInvoice() {
        System.assertEquals(1, CalK4B_InvoiceService.countByName('CalK4B-INV-001'));
    }
}