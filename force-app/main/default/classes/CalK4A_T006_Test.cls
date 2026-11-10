@IsTest
private with sharing class CalK4A_T006_Test {
    @IsTest
    static void utilSharingByCaller() {
        insert new List<CalK4A_DemoInvoice__c>{ new CalK4A_DemoInvoice__c(Name = 'INV-A'), new CalK4A_DemoInvoice__c(Name = 'INV-B') };
        User rep = CalK4A_TestUsers.make('k4arep6', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Integer fromWith;
        Integer fromWithout;
        System.runAs(rep) {
            fromWith = CalK4A_DemoMoneyCallerWith.count();
            fromWithout = CalK4A_DemoMoneyCallerWithout.count();
            Test.startTest();
            System.enqueueJob(new CalK4A_DemoMoneyUtil());
            Test.stopTest();
        }
        CalK4A_DemoKnowledgeTip__c tip = [SELECT Name, CreatedBy.Alias FROM CalK4A_DemoKnowledgeTip__c WHERE Name LIKE 'CalK4A_T006_entrypoint_count=%' LIMIT 1];
        String entry = tip.Name;
        String body = [SELECT Body FROM ApexClass WHERE Name = 'CalK4A_DemoMoneyUtil'].Body;
        CalK4A_TestUsers.obs('T-006', new Map<String, Object>{ 'declaration' => body.substringBefore('{').trim(),
            'invoiceOwd' => CalK4A_TestUsers.owd('CalK4A_DemoInvoice__c'), 'adminOwned' => 2,
            'calledFromWithSharing' => fromWith, 'calledFromWithoutSharing' => fromWithout,
            'asQueueableEntryPoint' => entry.substringAfter('='), 'queueableRanAs' => tip.CreatedBy.Alias, 'repAlias' => rep.Alias });
        Assert.isTrue(fromWith <= fromWithout, 'with-sharing caller must never see more than without-sharing caller');
    }
}