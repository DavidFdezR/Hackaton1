/**
 * ARMX golden case 03. Assertions encode the OBSERVED outcome in hack1 (2026-11-10) with the
 * ARMX_HACK_GC03_Set_Proposal flow active: the flow's after-save update re-enters the before-update
 * trigger exactly once, the trigger wins, final StageName = Qualification, no DML error.
 */
@IsTest
private class ARMX_HACK_GC03_OppStageHandlerTest {
    private static Opportunity newOpp(String name, String stage) {
        return new Opportunity(Name = name, StageName = stage, CloseDate = Date.today().addDays(30));
    }

    @IsTest
    static void handlerForcesQualificationOnPrefixedRecordsOnly() {
        Opportunity hit = newOpp('ARMX_HACK_GC03_Unit', 'Prospecting');
        Opportunity miss = newOpp('Synthetic Other Opp', 'Prospecting');
        ARMX_HACK_GC03_OppStageHandler.apply(new List<Opportunity>{ hit, miss }, true);
        Assert.areEqual('Qualification', hit.StageName);
        Assert.areEqual('Prospecting', miss.StageName);
    }

    @IsTest
    static void insertEndsInQualificationAfterFlowReentry() {
        ARMX_HACK_GC03_OppStageHandler.runCount = 0;
        Opportunity o = newOpp('ARMX_HACK_GC03_Insert', 'Prospecting');
        Test.startTest();
        Database.SaveResult sr = Database.insert(o, false);
        Test.stopTest();
        Assert.isTrue(sr.isSuccess(), 'Unexpected DML error: ' + sr.getErrors());
        Assert.areEqual(2, ARMX_HACK_GC03_OppStageHandler.runCount, 'Expected beforeInsert + one re-entry from the flow update');
        Assert.areEqual('Qualification', [SELECT StageName FROM Opportunity WHERE Id = :o.Id].StageName);
    }

    @IsTest
    static void userUpdateToOtherStageAlsoEndsInQualification() {
        Opportunity o = newOpp('ARMX_HACK_GC03_Update', 'Prospecting');
        insert o;
        ARMX_HACK_GC03_OppStageHandler.runCount = 0;
        o.StageName = 'Negotiation/Review';
        Test.startTest();
        Database.SaveResult sr = Database.update(o, false);
        Test.stopTest();
        Assert.isTrue(sr.isSuccess(), 'Unexpected DML error: ' + sr.getErrors());
        Assert.areEqual(2, ARMX_HACK_GC03_OppStageHandler.runCount);
        Assert.areEqual('Qualification', [SELECT StageName FROM Opportunity WHERE Id = :o.Id].StageName);
    }

    @IsTest
    static void nonPrefixedOpportunityIsUntouchedByBothAutomations() {
        Opportunity o = newOpp('Synthetic Other Opp', 'Prospecting');
        insert o;
        Assert.areEqual('Prospecting', [SELECT StageName FROM Opportunity WHERE Id = :o.Id].StageName);
    }

    @IsTest
    static void bulkInsertOf200StaysWithinLimitsAndEndsInQualification() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            opps.add(newOpp('ARMX_HACK_GC03_Bulk_' + i, 'Prospecting'));
        }
        Test.startTest();
        insert opps;
        Test.stopTest();
        Assert.areEqual(200, [SELECT COUNT() FROM Opportunity WHERE Name LIKE 'ARMX_HACK_GC03_Bulk_%' AND StageName = 'Qualification']);
    }
}