@isTest
private class CalOpportunityStageServiceTest {
    static List<Opportunity> makeOpportunities(Integer howMany) {
        Account a = new Account(Name = 'Cal Opp Owner');
        insert a;
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < howMany; i++) {
            opps.add(new Opportunity(Name = 'Cal Opp ' + i, AccountId = a.Id,
                StageName = 'Prospecting', CloseDate = Date.today().addDays(30)));
        }
        insert opps;
        return opps;
    }

    @isTest
    static void bulkCloseUsesSetOrientedDml() {
        List<Id> ids = new List<Id>(new Map<Id, Opportunity>(makeOpportunities(200)).keySet());
        Test.startTest();
        List<String> errors = CalOpportunityStageService.closeWon(ids);
        Integer dmlStatements = Limits.getDmlStatements();
        Test.stopTest();
        Assert.isTrue(dmlStatements <= 2, 'Expected set-oriented DML, but used ' + dmlStatements + ' statements');
        Assert.areEqual(0, errors.size());
        Assert.areEqual(200, [SELECT COUNT() FROM Opportunity WHERE StageName = 'Closed Won']);
    }

    @isTest
    static void oneBadRecordDoesNotSinkTheBatch() {
        List<Opportunity> opps = makeOpportunities(3);
        delete opps[1];
        List<Id> ids = new List<Id>{ opps[0].Id, opps[1].Id, opps[2].Id };
        Test.startTest();
        List<String> errors = CalOpportunityStageService.closeWon(ids);
        Test.stopTest();
        Assert.areEqual(1, errors.size(), 'The deleted record should be reported, not thrown');
        Assert.areEqual(2, [SELECT COUNT() FROM Opportunity WHERE StageName = 'Closed Won']);
    }
}