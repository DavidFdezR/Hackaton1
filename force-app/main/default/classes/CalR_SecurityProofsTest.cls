@IsTest
private class CalR_SecurityProofsTest {
    static User admin() {
        return new User(Id = UserInfo.getUserId());
    }

    static User demoUser(String alias) {
        Profile standard = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String unique = alias + String.valueOf(Crypto.getRandomInteger()).replace('-', '');
        User u = new User(Alias = alias, LastName = 'CalR ' + alias, Email = unique + '@calr.example',
            Username = unique + '@calr.example', ProfileId = standard.Id, TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        System.runAs(admin()) {
            insert u;
        }
        return u;
    }

    static void assign(User u, String permissionSetName) {
        Id psId = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName].Id;
        System.runAs(admin()) {
            insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = psId);
        }
    }

    static UserPermissionAccess access(User u) {
        UserPermissionAccess result;
        System.runAs(u) {
            result = [SELECT PermissionsCanApproveUninstalledApps, PermissionsApiEnabled FROM UserPermissionAccess LIMIT 1];
        }
        return result;
    }

    @IsTest
    static void approveUninstalledAppsComesOnlyFromTheGrant() {
        User rep = demoUser('calrrep');
        System.assertEquals(false, access(rep).PermissionsCanApproveUninstalledApps, 'Standard User lacks it');
        assign(rep, 'CalR_DemoSales_Field');
        System.assertEquals(true, access(rep).PermissionsCanApproveUninstalledApps, 'Permission set grants it to a plain rep');
    }

    @IsTest
    static void lightningLoginUserComesFromTheGrant() {
        User adminUser = demoUser('calrll');
        assign(adminUser, 'CalR_DemoAdmin_LightningLogin');
        Integer grants = [SELECT COUNT() FROM PermissionSetAssignment
                          WHERE AssigneeId = :adminUser.Id AND PermissionSet.PermissionsAllowLightningLogin = true];
        System.assertEquals(1, grants, 'Lightning Login User arrives through an ordinary permission set assignment');
    }

    @IsTest
    static void viewAllWidensAgentReachPastPrivateSharing() {
        User owner = demoUser('calrown');
        assign(owner, 'CalR_DemoAccount_Writer');
        System.runAs(owner) {
            insert new CalR_DemoAccount__c(Name = 'CalR Demo Deal Account', Amount__c = 480000);
        }
        User agent = demoUser('calragt');
        assign(agent, 'CalR_DemoAccount_Reader');
        Integer readerSees;
        System.runAs(agent) {
            readerSees = [SELECT COUNT() FROM CalR_DemoAccount__c WITH USER_MODE];
        }
        assign(agent, 'CalR_DemoAgent_Triage');
        Integer triageSees;
        System.runAs(agent) {
            triageSees = [SELECT COUNT() FROM CalR_DemoAccount__c WITH USER_MODE];
        }
        System.assertEquals(0, readerSees, 'Private OWD hides records owned by others');
        System.assertEquals(1, triageSees, 'View All shows every record regardless of owner');
    }

    @IsTest
    static void integrationPasswordResetHasNoExtraGate() {
        User integration = demoUser('calrint');
        System.ResetPasswordResult result;
        System.runAs(admin()) {
            result = System.resetPassword(integration.Id, false);
        }
        System.assertNotEquals(null, result.getPassword(), 'An admin session resets the integration user password directly');
    }
}