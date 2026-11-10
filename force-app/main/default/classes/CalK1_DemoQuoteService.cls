public with sharing class CalK1_DemoQuoteService {
    public static Decimal calculateTotal(List<Decimal> lines) {
        Decimal sum = 0;
        if (lines == null) {
            return sum;
        }
        for (Decimal line : lines) {
            if (line != null) {
                sum += line;
            }
        }
        System.debug('CalK1 quote total calculated: ' + sum);
        return sum;
    }

    public static String formatTotal(Decimal total) {
        return 'USD ' + (total == null ? 0 : total).setScale(2);
    }
}