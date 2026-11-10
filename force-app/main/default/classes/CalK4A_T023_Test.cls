@IsTest
private with sharing class CalK4A_T023_Test {
    static PermissionSet madPs;
    static User sysAdmin;

    static Map<String, Object> attempt(User actor, User target) {
        Map<String, Object> r = new Map<String, Object>();
        Id adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id auditorPs = [SELECT Id FROM PermissionSet WHERE Name = 'CalK4A_DemoFinance_Auditor'].Id;
        System.runAs(actor) {
            r.put('setTargetProfileToSystemAdministrator', CalK4A_Probe.tryUpdateSystem(new User(Id = target.Id, ProfileId = adminProfile)));
            r.put('selfAssignAnyPermissionSet', CalK4A_Probe.tryInsert(new PermissionSetAssignment(AssigneeId = actor.Id, PermissionSetId = auditorPs)));
            try {
                System.resetPassword(target.Id, false);
                r.put('resetTargetPassword', 'ok');
            } catch (Exception e) {
                r.put('resetTargetPassword', e.getMessage().left(160));
            }
        }
        r.put('targetProfileAfter', [SELECT Profile.Name FROM User WHERE Id = :target.Id].Profile.Name);
        if (madPs != null) {
            System.runAs(actor) {
                r.put('selfAssignModifyAllDataPermSet', CalK4A_Probe.tryInsert(new PermissionSetAssignment(AssigneeId = actor.Id, PermissionSetId = madPs.Id)));
                r.put('editSysAdminEmail', CalK4A_Probe.tryUpdateSystem(new User(Id = sysAdmin.Id, Email = 'attacker@calk4a.example')));
            }
        }
        return r;
    }

    @IsTest
    static void manageUsersVersusResetOnly() {
        Map<String, Object> o = new Map<String, Object>();
        PermissionSet manage = CalK4A_Probe.permSet('CalK4A_T023_Manage', new List<String>{ 'ManageUsers', 'AssignPermissionSets',
            'DelegatedTwoFactor', 'FreezeUsers', 'ManageInternalUsers', 'ManageIpAddresses', 'ManageLoginAccessPolicies',
            'ManagePasswordPolicies', 'ManageProfilesPermissionsets', 'ManageRoles', 'ManageSharing', 'MonitorLoginHistory',
            'ResetPasswords', 'ViewAllUsers', 'ViewRoles', 'ViewSetup' });
        PermissionSet resetOnly = CalK4A_Probe.permSet('CalK4A_T023_Reset', new List<String>{ 'ResetPasswords', 'ViewRoles', 'ViewSetup' });
        System.runAs(new User(Id = UserInfo.getUserId())) {
            o.put('saveManageUsersOnly', CalK4A_Probe.tryInsert(CalK4A_Probe.permSet('CalK4A_T023_Bare', new List<String>{ 'ManageUsers' })));
            o.put('saveManageUsersWithDeps', CalK4A_Probe.tryInsert(manage));
            o.put('saveResetOnly', CalK4A_Probe.tryInsert(resetOnly));
        }
        User help = CalK4A_TestUsers.make('k4ahelp', 'Standard User', null, new List<String>{ 'CalK4A_DemoHelpdesk' });
        User resetter = CalK4A_TestUsers.make('k4arst', 'Standard User', null, new List<String>{ 'CalK4A_DemoHelpdesk' });
        User target1 = CalK4A_TestUsers.make('k4atgt1', 'Standard User', null, null);
        System.runAs(new User(Id = UserInfo.getUserId())) {
            if (manage.Id != null) insert new PermissionSetAssignment(AssigneeId = help.Id, PermissionSetId = manage.Id);
            if (resetOnly.Id != null) insert new PermissionSetAssignment(AssigneeId = resetter.Id, PermissionSetId = resetOnly.Id);
        }
        sysAdmin = CalK4A_TestUsers.make('k4asadm', 'System Administrator', null, null);
        madPs = CalK4A_Probe.permSet('CalK4A_T023_Mad', new List<String>{ 'ModifyAllData', 'AssignTopics', 'ConnectOrgToEnvironmentHub',
            'ConvertLeads', 'CreateCustomizeDashboards', 'CreateCustomizeFilters', 'CreateCustomizeReports', 'CreateDashboardFolders',
            'CreateReportFolders', 'CreateTopics', 'DeleteTopics', 'EditEvent', 'EditMyDashboards', 'EditMyReports', 'EditPublicDocuments',
            'EditPublicFilters', 'EditPublicTemplates', 'EditTask', 'EditTopics', 'ImportLeads', 'ManageCategories', 'ManageDashbdsInPubFolders',
            'ManageNetworks', 'ManageReportsInPubFolders', 'ModifyMetadata', 'RunReports', 'SolutionImport', 'TransferAnyEntity',
            'TransferAnyLead', 'UseTeamReassignWizards', 'ViewAllData', 'ViewDataLeakageEvents', 'ViewEventLogFiles', 'ViewPlatformEvents',
            'ViewPublicDashboards', 'ViewPublicReports', 'ViewRoles', 'ViewSetup' });
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert madPs;
        }
        o.put('resetOnlyUser', attempt(resetter, target1));
        o.put('manageUsersUser', attempt(help, target1));
        CalK4A_TestUsers.obs('T-023', o);
        Assert.isNotNull(o.get('manageUsersUser'));
    }
}