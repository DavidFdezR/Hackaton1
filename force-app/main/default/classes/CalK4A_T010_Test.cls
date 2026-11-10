@IsTest
private with sharing class CalK4A_T010_Test {
    @IsTest
    static void managerChainAccessFollowsRoleParent() {
        User repE = CalK4A_TestUsers.make('k4arepE', 'Standard Platform User', 'CalK4A_Sales_Rep_EMEA', new List<String>{ 'CalK4A_DemoRep_Base' });
        User mgrE = CalK4A_TestUsers.make('k4amgrE', 'Standard Platform User', 'CalK4A_Sales_Manager_EMEA', new List<String>{ 'CalK4A_DemoRep_Base' });
        User mgrA = CalK4A_TestUsers.make('k4amgrA', 'Standard Platform User', 'CalK4A_Sales_Manager_APAC', new List<String>{ 'CalK4A_DemoRep_Base' });
        CalK4A_DemoInvoice__c inv = new CalK4A_DemoInvoice__c(Name = 'EMEA rep invoice');
        System.runAs(repE) {
            insert inv;
        }
        UserRole rep = [SELECT ParentRole.DeveloperName FROM UserRole WHERE DeveloperName = 'CalK4A_Sales_Rep_EMEA'];
        Map<Id, UserRecordAccess> e = CalK4A_TestUsers.access(mgrE.Id, new Set<Id>{ inv.Id });
        Map<Id, UserRecordAccess> a = CalK4A_TestUsers.access(mgrA.Id, new Set<Id>{ inv.Id });
        CalK4A_TestUsers.obs('T-010', new Map<String, Object>{ 'repRoleParent' => rep.ParentRole.DeveloperName,
            'invoiceOwd' => CalK4A_TestUsers.owd('CalK4A_DemoInvoice__c'),
            'mgrE_read' => e.get(inv.Id).HasReadAccess, 'mgrE_edit' => e.get(inv.Id).HasEditAccess,
            'mgrA_read' => a.get(inv.Id).HasReadAccess, 'mgrA_edit' => a.get(inv.Id).HasEditAccess });
        Assert.isNotNull(rep);
    }
}