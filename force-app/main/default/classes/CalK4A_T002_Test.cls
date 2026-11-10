@IsTest
private with sharing class CalK4A_T002_Test {
    @IsTest
    static void nonOwnerReaderVisibilityFollowsTipOwd() {
        List<CalK4A_DemoKnowledgeTip__c> tips = new List<CalK4A_DemoKnowledgeTip__c>{
            new CalK4A_DemoKnowledgeTip__c(Name = 'Tip 1'), new CalK4A_DemoKnowledgeTip__c(Name = 'Tip 2'),
            new CalK4A_DemoKnowledgeTip__c(Name = 'Tip 3')
        };
        insert tips;
        User reader = CalK4A_TestUsers.make('k4ardr1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Integer seen;
        String error = 'none';
        System.runAs(reader) {
            try {
                seen = [SELECT COUNT() FROM CalK4A_DemoKnowledgeTip__c WHERE Name LIKE 'Tip %' WITH USER_MODE];
            } catch (Exception e) {
                error = e.getMessage();
            }
        }
        String owd = CalK4A_TestUsers.owd('CalK4A_DemoKnowledgeTip__c');
        CalK4A_TestUsers.obs('T-002', new Map<String, Object>{ 'owd' => owd, 'adminOwned' => 3, 'nonOwnerReaderSees' => seen,
            'errorRaised' => error, 'adminStillSees' => [SELECT COUNT() FROM CalK4A_DemoKnowledgeTip__c WHERE Name LIKE 'Tip %'] });
        Assert.areEqual(owd == 'Private' ? 0 : 3, seen);
    }
}