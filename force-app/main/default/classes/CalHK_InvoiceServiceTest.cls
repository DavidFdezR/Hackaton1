// T-516 / S-444 / F-384: the single test class used in the RunSpecifiedTests validations.
@isTest
private class CalHK_InvoiceServiceTest {
    @isTest static void taxIsEighteenPercent() { System.assertEquals(18, CalHK_InvoiceService.calcTax(100)); }
    @isTest static void describeTrimsBothParts() { System.assertEquals('a / b', CalHK_InvoiceService.describe(' a', 'b ')); }
}