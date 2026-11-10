@IsTest
private with sharing class CalK4A_T005_Test {
    @IsTest
    static void controllerSharingDecidesWhatRepSees() {
        insert new List<CalK4A_DemoInvoice__c>{ new CalK4A_DemoInvoice__c(Name = 'INV-A'), new CalK4A_DemoInvoice__c(Name = 'INV-B') };
        User rep = CalK4A_TestUsers.make('k4arep5', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Integer viaController;
        Integer viaListView;
        System.runAs(rep) {
            viaController = CalK4A_DemoInvoiceController.getInvoices().size();
            viaListView = [SELECT COUNT() FROM CalK4A_DemoInvoice__c WITH USER_MODE];
        }
        String body = [SELECT Body FROM ApexClass WHERE Name = 'CalK4A_DemoInvoiceController'].Body;
        CalK4A_TestUsers.obs('T-005', new Map<String, Object>{ 'declaration' => body.substringBefore('{').trim(),
            'invoiceOwd' => CalK4A_TestUsers.owd('CalK4A_DemoInvoice__c'),
            'repViaAuraEnabledController' => viaController, 'repViaUserModeQuery' => viaListView });
        Assert.isNotNull(viaController);
    }
}