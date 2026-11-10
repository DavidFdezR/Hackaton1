@IsTest
private class CalK1_DemoQuoteServiceTest {
    @IsTest
    static void nullListIsZero() {
        System.assertEquals(0, CalK1_DemoQuoteService.calculateTotal(null));
    }
    @IsTest
    static void emptyListIsZero() {
        System.assertEquals(0, CalK1_DemoQuoteService.calculateTotal(new List<Decimal>()));
    }
    @IsTest
    static void singleLine() {
        System.assertEquals(12.5, CalK1_DemoQuoteService.calculateTotal(new List<Decimal>{ 12.5 }));
    }
    @IsTest
    static void severalLines() {
        System.assertEquals(60, CalK1_DemoQuoteService.calculateTotal(new List<Decimal>{ 10, 20, 30 }));
    }
    @IsTest
    static void nullLinesSkipped() {
        System.assertEquals(5, CalK1_DemoQuoteService.calculateTotal(new List<Decimal>{ null, 5, null }));
    }
    @IsTest
    static void creditsReduceTotal() {
        System.assertEquals(7, CalK1_DemoQuoteService.calculateTotal(new List<Decimal>{ 10, -3 }));
    }
}