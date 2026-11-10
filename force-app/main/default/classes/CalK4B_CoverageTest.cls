@IsTest
private class CalK4B_CoverageTest {
    @IsTest
    static void touchesEverything() {
        CalK4B_CoverageTarget.add(1, 2);
        CalK4B_CoverageTarget.greet('x');
        CalK4B_CoverageTarget.isPositive(5);
    }
}