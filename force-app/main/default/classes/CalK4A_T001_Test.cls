@IsTest
private with sharing class CalK4A_T001_Test {
    @IsTest
    static void repVisibilityFollowsInvoiceOwd() {
        List<CalK4A_DemoInvoice__c> invoices = new List<CalK4A_DemoInvoice__c>{
            new CalK4A_DemoInvoice__c(Name = 'INV-1', Amount__c = 1200, Payment_Terms__c = 'Net 30'),
            new CalK4A_DemoInvoice__c(Name = 'INV-2', Amount__c = 900, Payment_Terms__c = 'Net 60')
        };
        insert invoices;
        User rep = CalK4A_TestUsers.make('k4arep1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Integer seen;
        System.runAs(rep) {
            seen = [SELECT COUNT() FROM CalK4A_DemoInvoice__c WITH USER_MODE];
        }
        Map<Id, UserRecordAccess> acc = CalK4A_TestUsers.access(rep.Id, new Map<Id, CalK4A_DemoInvoice__c>(invoices).keySet());
        String owd = CalK4A_TestUsers.owd('CalK4A_DemoInvoice__c');
        CalK4A_TestUsers.obs('T-001', new Map<String, Object>{ 'owd' => owd, 'adminOwned' => 2, 'repSees' => seen,
            'repHasEdit' => acc.get(invoices[0].Id).HasEditAccess, 'repMaxAccess' => acc.get(invoices[0].Id).MaxAccessLevel });
        Assert.areEqual(owd == 'Private' ? 0 : 2, seen, 'rep visibility must follow OWD ' + owd);
    }
}