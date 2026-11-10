// T-516: second relevant test class added to the RunSpecifiedTests list.
@isTest
private class CalHK_QuoteServiceTest {
    @isTest static void quoteAppliesMargin() { System.assertEquals(125, CalHK_QuoteService.quote(100)); }
}