@IsTest
private with sharing class CalK4A_T003_Test {
    @IsTest
    static void allInternalUsersRuleGrantsEdit() {
        List<CalK4A_DemoContract__c> contracts = new List<CalK4A_DemoContract__c>{
            new CalK4A_DemoContract__c(Name = 'Renewal A'), new CalK4A_DemoContract__c(Name = 'Renewal B')
        };
        insert contracts;
        User anyone = CalK4A_TestUsers.make('k4aren1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Integer seen;
        String editResult = 'not attempted';
        System.runAs(anyone) {
            seen = [SELECT COUNT() FROM CalK4A_DemoContract__c WITH USER_MODE];
            try {
                Database.update(new CalK4A_DemoContract__c(Id = contracts[0].Id, Name = 'Renewal A edited by non-owner'), AccessLevel.USER_MODE);
                editResult = 'saved';
            } catch (Exception e) {
                editResult = e.getMessage().left(160);
            }
        }
        List<AggregateResult> shares = [SELECT RowCause rc, AccessLevel lvl, COUNT(Id) n FROM CalK4A_DemoContract__Share
                                        WHERE ParentId IN :contracts GROUP BY RowCause, AccessLevel];
        CalK4A_TestUsers.obs('T-003', new Map<String, Object>{ 'owd' => CalK4A_TestUsers.owd('CalK4A_DemoContract__c'),
            'nonOwnerSees' => seen, 'nonOwnerEdit' => editResult, 'shareRows' => shares });
        Assert.isNotNull(seen);
    }
}