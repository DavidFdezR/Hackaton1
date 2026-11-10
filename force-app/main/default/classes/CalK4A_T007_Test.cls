@IsTest
private with sharing class CalK4A_T007_Test {
    @IsTest
    static void viewAllAuditorsSeeEveryInvoice() {
        insert new List<CalK4A_DemoInvoice__c>{ new CalK4A_DemoInvoice__c(Name = 'INV-A'), new CalK4A_DemoInvoice__c(Name = 'INV-B') };
        User a1 = CalK4A_TestUsers.make('k4aaud1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoFinance_Auditor' });
        User a2 = CalK4A_TestUsers.make('k4aaud2', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoFinance_Auditor' });
        User rep = CalK4A_TestUsers.make('k4arep7', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        Map<String, Integer> seen = new Map<String, Integer>();
        for (User u : new List<User>{ a1, a2, rep }) {
            System.runAs(u) {
                seen.put(u.Alias, [SELECT COUNT() FROM CalK4A_DemoInvoice__c WITH USER_MODE]);
            }
        }
        String editByAuditor;
        System.runAs(a1) {
            try {
                Database.update(new CalK4A_DemoInvoice__c(Id = [SELECT Id FROM CalK4A_DemoInvoice__c LIMIT 1].Id, Name = 'x'), AccessLevel.USER_MODE);
                editByAuditor = 'saved';
            } catch (Exception e) {
                editByAuditor = e.getMessage().left(120);
            }
        }
        ObjectPermissions op = [SELECT PermissionsRead, PermissionsEdit, PermissionsViewAllRecords, PermissionsModifyAllRecords
                                FROM ObjectPermissions WHERE Parent.Name = 'CalK4A_DemoFinance_Auditor' AND SobjectType = 'CalK4A_DemoInvoice__c'];
        CalK4A_TestUsers.obs('T-007', new Map<String, Object>{ 'invoiceOwd' => CalK4A_TestUsers.owd('CalK4A_DemoInvoice__c'),
            'seenByAlias' => seen, 'auditorEdit' => editByAuditor, 'objectPermissions' => op,
            'assigneesInTest' => [SELECT COUNT() FROM PermissionSetAssignment WHERE PermissionSet.Name = 'CalK4A_DemoFinance_Auditor'] });
        Assert.areEqual(2, seen.get(a1.Alias));
    }
}