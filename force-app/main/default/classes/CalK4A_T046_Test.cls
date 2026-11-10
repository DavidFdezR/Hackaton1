@IsTest
private class CalK4A_T046_Test {
    @IsTest
    static void twoBeforeUpdateTriggers() {
        CalK4A_DemoAccount__c a = new CalK4A_DemoAccount__c(Name = 'Order demo', Tier__c = 'Gold');
        insert a;
        update new CalK4A_DemoAccount__c(Id = a.Id, Region__c = null);
        CalK4A_DemoAccount__c after = [SELECT Region__c, Notes2__c FROM CalK4A_DemoAccount__c WHERE Id = :a.Id];
        CalK4A_TestUsers.obs('T-046', new Map<String, Object>{ 'regionAfter' => after.Region__c, 'auditNotes2' => after.Notes2__c,
            'triggersOnObject' => [SELECT Name, Status FROM ApexTrigger WHERE TableEnumOrId = 'CalK4A_DemoAccount__c'] });
        Assert.isNotNull(after.Notes2__c);
    }
}