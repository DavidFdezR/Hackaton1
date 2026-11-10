@IsTest
private with sharing class CalK4A_T013_T014_Test {
    @IsTest
    static void repFieldAccess() {
        CalK4A_DemoAccount__c a = new CalK4A_DemoAccount__c(Name = 'Acme demo', Tier__c = 'Gold', Credit_Limit__c = 1000,
            Status__c = 'Active', Region__c = 'EMEA');
        insert a;
        User rep = CalK4A_TestUsers.make('k4arep13', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoSales_Rep' });
        Map<String, Object> o = new Map<String, Object>();
        System.runAs(rep) {
            o.put('T013_repSetsCreditLimit', CalK4A_Probe.tryUpdate(new CalK4A_DemoAccount__c(Id = a.Id, Credit_Limit__c = 50000)));
            try {
                o.put('T014_repReadsRegion', Database.query('SELECT Region__c FROM CalK4A_DemoAccount__c WHERE Id = \'' + a.Id + '\' WITH USER_MODE')[0].get('Region__c'));
            } catch (Exception e) {
                o.put('T014_repReadsRegion', e.getMessage().left(160));
            }
            o.put('T014_repEditsRegion', CalK4A_Probe.tryUpdate(new CalK4A_DemoAccount__c(Id = a.Id, Region__c = 'APAC')));
        }
        o.put('T013_fls_Credit_Limit', CalK4A_Probe.fieldPerm('CalK4A_DemoSales_Rep', 'CalK4A_DemoAccount__c.Credit_Limit__c'));
        o.put('T014_fls_Region', CalK4A_Probe.fieldPerm('CalK4A_DemoSales_Rep', 'CalK4A_DemoAccount__c.Region__c'));
        CalK4A_TestUsers.obs('T-013/T-014', o);
        Assert.isNotNull(o.get('T013_repSetsCreditLimit'));
    }
}