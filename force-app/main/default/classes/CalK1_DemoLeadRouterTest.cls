@IsTest
private class CalK1_DemoLeadRouterTest {
    @IsTest
    static void westStates() {
        System.assertEquals('West', CalK1_DemoLeadRouter.route('CA'));
    }
    @IsTest
    static void eastStates() {
        System.assertEquals('East', CalK1_DemoLeadRouter.route('NY'));
    }
    @IsTest
    static void everythingElseIsCentral() {
        System.assertEquals('Central', CalK1_DemoLeadRouter.route('TX'));
    }
}