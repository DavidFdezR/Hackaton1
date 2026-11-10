@IsTest
private with sharing class CalK4A_T032_Test {
    @IsTest
    static void integrationUserToSystemAdministrator() {
        CalK4A_DemoInvoice__c inv = new CalK4A_DemoInvoice__c(Name = 'INV-INT2');
        CalK4A_DemoContract__c con = new CalK4A_DemoContract__c(Name = 'Contract for T-032');
        insert inv;
        insert con;
        Map<String, Object> o = new Map<String, Object>();
        User integ;
        try {
            integ = CalK4A_TestUsers.make('k4aint2', 'Minimum Access - API Only Integrations', null, new List<String>{ 'CalK4A_DemoIntegration_PS' });
        } catch (Exception e) {
            o.put('createIntegrationUser', e.getMessage().left(200));
        }
        if (integ != null) {
            o.put('licenceBefore', [SELECT Profile.UserLicense.Name FROM User WHERE Id = :integ.Id].Profile.UserLicense.Name);
            System.runAs(integ) {
                o.put('before_updateInvoice', CalK4A_Probe.tryUpdate(new CalK4A_DemoInvoice__c(Id = inv.Id, Name = 'x')));
                o.put('before_updateContract', CalK4A_Probe.tryUpdate(new CalK4A_DemoContract__c(Id = con.Id, Name = 'x')));
            }
            Id sysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            System.runAs(new User(Id = UserInfo.getUserId())) {
                o.put('changeProfileToSystemAdministrator', CalK4A_Probe.tryUpdateSystem(new User(Id = integ.Id, ProfileId = sysAdmin)));
            }
            User after = [SELECT Profile.Name, Profile.UserLicense.Name FROM User WHERE Id = :integ.Id];
            o.put('profileAfter', after.Profile.Name);
            o.put('licenceAfter', after.Profile.UserLicense.Name);
            System.runAs(integ) {
                o.put('after_updateInvoice', CalK4A_Probe.tryUpdate(new CalK4A_DemoInvoice__c(Id = inv.Id, Name = 'x')));
                o.put('after_updateContract', CalK4A_Probe.tryUpdate(new CalK4A_DemoContract__c(Id = con.Id, Name = 'x')));
            }
            o.put('after_contractAccess', CalK4A_TestUsers.access(integ.Id, new Set<Id>{ con.Id }).get(con.Id));
        }
        o.put('profilesOnIntegrationLicence', [SELECT Name FROM Profile WHERE UserLicense.Name = 'Salesforce Integration']);
        CalK4A_TestUsers.obs('T-032', o);
        Assert.isNotNull(o);
    }
}