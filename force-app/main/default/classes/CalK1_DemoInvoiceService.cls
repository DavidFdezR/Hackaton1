public with sharing class CalK1_DemoInvoiceService {
    public static Decimal subtotal(List<Decimal> lines) {
        Decimal total = 0;
        if (lines == null) {
            return total;
        }
        for (Decimal line : lines) {
            if (line != null) {
                total += line;
            }
        }
        return total;
    }

    public static Decimal taxFor(Decimal amount, Decimal ratePercent) {
        if (amount == null || ratePercent == null) {
            return 0;
        }
        return roundTax(amount * ratePercent / 100);
    }

    public static Decimal invoiceTotal(List<Decimal> lines, Decimal ratePercent) {
        Decimal net = subtotal(lines);
        return net + taxFor(net, ratePercent);
    }

    public static Boolean isTaxable(String region) {
        if (region == null) {
            return false;
        }
        return region != 'West';
    }

    public static String describe(Decimal amount) {
        String label = 'Invoice amount: ';
        return label + amount;
    }

    public static Decimal roundTax(Decimal tax) {
        return tax.setScale(2, RoundingMode.HALF_UP);
    }
}