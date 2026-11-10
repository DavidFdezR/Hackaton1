@IsTest
private class CalK4B_LegacyTest {
    @IsTest
    static void labels() {
        System.assertEquals('ONE', CalK4B_Legacy.label(1));
        System.assertEquals('TWO', CalK4B_Legacy.label(2));
        System.assertEquals('OTHER', CalK4B_Legacy.label(3));
    }
}