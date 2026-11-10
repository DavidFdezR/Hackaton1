@IsTest
private with sharing class CalK4A_T016_Test {
    @IsTest
    static void authorApexAndCustomizeApplication() {
        Map<String, Object> o = new Map<String, Object>();
        User lead = CalK4A_TestUsers.make('k4alead', 'Standard User', null, new List<String>{ 'CalK4A_DemoSupport_Lead' });
        PermissionSet asRequested = CalK4A_Probe.permSet('CalK4A_T016_AsAsked', new List<String>{ 'AuthorApex', 'CustomizeApplication' });
        PermissionSet withDeps = CalK4A_Probe.permSet('CalK4A_T016_WithDeps', new List<String>{ 'AuthorApex', 'CustomizeApplication',
            'ModifyMetadata', 'ViewRoles', 'ViewSetup', 'ManageCustomPermissions' });
        System.runAs(new User(Id = UserInfo.getUserId())) {
            o.put('saveAsRequested', CalK4A_Probe.tryInsert(asRequested));
            o.put('saveWithDependencies', CalK4A_Probe.tryInsert(withDeps));
            if (withDeps.Id != null) {
                insert new PermissionSetAssignment(AssigneeId = lead.Id, PermissionSetId = withDeps.Id);
            }
        }
        System.runAs(lead) {
            o.put('leadCreatesModifyAllDataPermSet', CalK4A_Probe.tryInsert(new PermissionSet(Name = 'CalK4A_T016_Esc', Label = 'CalK4A T016 Esc', PermissionsModifyAllData = true)));
            o.put('leadSelfAssignsAuditorPermSet', CalK4A_Probe.tryInsert(new PermissionSetAssignment(AssigneeId = lead.Id,
                PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'CalK4A_DemoFinance_Auditor'].Id)));
        }
        if (withDeps.Id != null) {
            PermissionSet saved = [SELECT PermissionsAuthorApex, PermissionsCustomizeApplication, PermissionsModifyMetadata,
                                   PermissionsModifyAllData, PermissionsViewAllData FROM PermissionSet WHERE Id = :withDeps.Id];
            o.put('savedPermissionSet', saved);
        }
        CalK4A_TestUsers.obs('T-016', o);
        Assert.isNotNull(o.get('saveAsRequested'));
    }
}