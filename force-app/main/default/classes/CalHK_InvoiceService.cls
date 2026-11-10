// S-102 before-state: private helper formatLine with two call sites.
public with sharing class CalHK_InvoiceService {
    public static Decimal calcTax(Decimal amount) { return amount == null ? 0 : amount * 0.18; }
    public static String describe(String a, String b) { return formatLine(a) + ' / ' + formatLine(b); }
    private static String formatLine(String s) { return s == null ? '' : s.trim(); }
}