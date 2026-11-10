@IsTest
private with sharing class CalK4A_T004_Test {
    @IsTest
    static void emeaRuleSharesOnlyEmeaReadOnly() {
        Id queueId = [SELECT Id FROM Group WHERE DeveloperName = 'CalK4A_Demo_Triage' AND Type = 'Queue'].Id;
        CalK4A_DemoCase__c emea = new CalK4A_DemoCase__c(Name = 'EMEA case', Region__c = 'EMEA', OwnerId = queueId);
        CalK4A_DemoCase__c apac = new CalK4A_DemoCase__c(Name = 'APAC case', Region__c = 'APAC', OwnerId = queueId);
        insert new List<CalK4A_DemoCase__c>{ emea, apac };
        User agent = CalK4A_TestUsers.make('k4aemea', 'Standard Platform User', 'CalK4A_EMEA_Support', new List<String>{ 'CalK4A_DemoRep_Base' });
        List<String> seenRegions = new List<String>();
        System.runAs(agent) {
            for (CalK4A_DemoCase__c c : [SELECT Region__c FROM CalK4A_DemoCase__c WITH USER_MODE]) {
                seenRegions.add(c.Region__c);
            }
        }
        Map<Id, UserRecordAccess> acc = CalK4A_TestUsers.access(agent.Id, new Set<Id>{ emea.Id, apac.Id });
        List<AggregateResult> shares = [SELECT RowCause rc, AccessLevel lvl, COUNT(Id) n FROM CalK4A_DemoCase__Share
                                        WHERE ParentId = :emea.Id OR ParentId = :apac.Id GROUP BY RowCause, AccessLevel];
        CalK4A_TestUsers.obs('T-004', new Map<String, Object>{ 'agentSeesRegions' => seenRegions,
            'emeaEdit' => acc.get(emea.Id).HasEditAccess, 'emeaRead' => acc.get(emea.Id).HasReadAccess,
            'apacRead' => acc.get(apac.Id).HasReadAccess, 'shareRows' => shares });
        Assert.isFalse(acc.get(apac.Id).HasReadAccess);
    }
}