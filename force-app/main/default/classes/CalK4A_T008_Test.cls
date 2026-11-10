@IsTest
private with sharing class CalK4A_T008_Test {
    static final List<String> MAD_CHAIN = new List<String>{ 'ModifyAllData', 'AssignTopics', 'ConnectOrgToEnvironmentHub',
        'ConvertLeads', 'CreateCustomizeDashboards', 'CreateCustomizeFilters', 'CreateCustomizeReports', 'CreateDashboardFolders',
        'CreateReportFolders', 'CreateTopics', 'DeleteTopics', 'EditEvent', 'EditMyDashboards', 'EditMyReports', 'EditPublicDocuments',
        'EditPublicFilters', 'EditPublicTemplates', 'EditTask', 'EditTopics', 'ImportLeads', 'ManageCategories', 'ManageDashbdsInPubFolders',
        'ManageNetworks', 'ManageReportsInPubFolders', 'ModifyMetadata', 'RunReports', 'SolutionImport', 'TransferAnyEntity',
        'TransferAnyLead', 'UseTeamReassignWizards', 'ViewAllData', 'ViewDataLeakageEvents', 'ViewEventLogFiles', 'ViewPlatformEvents',
        'ViewPublicDashboards', 'ViewPublicReports', 'ViewRoles', 'ViewSetup', 'ApiEnabled' };

    static String tryUpdate(SObject rec) {
        try {
            Database.update(rec, AccessLevel.USER_MODE);
            return 'saved';
        } catch (Exception e) {
            return e.getMessage().left(140);
        }
    }

    @IsTest
    static void modifyAllDataOnIntegrationPermissionSet() {
        CalK4A_DemoInvoice__c inv = new CalK4A_DemoInvoice__c(Name = 'INV-INT');
        CalK4A_DemoContract__c con = new CalK4A_DemoContract__c(Name = 'Unrelated contract');
        CalK4A_DemoProject__c proj = new CalK4A_DemoProject__c(Name = 'Unrelated project');
        insert inv;
        insert con;
        insert proj;
        User integ = CalK4A_TestUsers.make('k4aint1', 'Standard User', null, new List<String>{ 'CalK4A_DemoIntegration_PS' });
        Map<String, Object> o = new Map<String, Object>();
        System.runAs(integ) {
            o.put('before_updateInvoice', tryUpdate(new CalK4A_DemoInvoice__c(Id = inv.Id, Name = 'x')));
            o.put('before_seesContracts', [SELECT COUNT() FROM CalK4A_DemoContract__c]);
        }
        PermissionSet mad = new PermissionSet(Name = 'CalK4A_T008_MAD', Label = 'CalK4A T008 MAD');
        for (String p : MAD_CHAIN) {
            mad.put('Permissions' + p, true);
        }
        System.runAs(new User(Id = UserInfo.getUserId())) {
            try {
                insert mad;
                insert new PermissionSetAssignment(AssigneeId = integ.Id, PermissionSetId = mad.Id);
                o.put('madPermissionSetSaved', true);
            } catch (Exception e) {
                o.put('madPermissionSetSaved', e.getMessage());
            }
        }
        System.runAs(integ) {
            o.put('after_updateInvoice', tryUpdate(new CalK4A_DemoInvoice__c(Id = inv.Id, Name = 'x')));
            o.put('after_updateUnrelatedContract', tryUpdate(new CalK4A_DemoContract__c(Id = con.Id, Name = 'edited by integration')));
            o.put('after_updateUnrelatedProject', tryUpdate(new CalK4A_DemoProject__c(Id = proj.Id, Name = 'edited by integration')));
            o.put('after_seesContracts', [SELECT COUNT() FROM CalK4A_DemoContract__c WITH USER_MODE]);
            o.put('after_seesAllUsers', [SELECT COUNT() FROM User WITH USER_MODE]);
        }
        Map<Id, UserRecordAccess> acc = CalK4A_TestUsers.access(integ.Id, new Set<Id>{ con.Id, proj.Id, inv.Id });
        o.put('after_deleteAccessOnContract', acc.get(con.Id).HasDeleteAccess);
        o.put('after_deleteAccessOnProject', acc.get(proj.Id).HasDeleteAccess);
        CalK4A_TestUsers.obs('T-008', o);
        Assert.isNotNull(o.get('after_updateInvoice'));
    }
}