@IsTest
private class CalR_RenewalServiceTest {
    @IsTest
    static void largeDealsNeedApproval() {
        System.assert(CalR_RenewalService.needsApproval(100000), 'A 100k deal is Large and needs approval');
        System.assert(!CalR_RenewalService.needsApproval(99999), 'Below 100k needs no approval');
    }
}