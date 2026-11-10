@IsTest
private class CalR_ForecastServiceTest {
    @IsTest
    static void largeDealsNeedApproval() {
        System.assert(CalR_ForecastService.needsApproval(100000), 'A 100k deal is Large and needs approval');
        System.assert(!CalR_ForecastService.needsApproval(99999), 'Below 100k needs no approval');
    }
}