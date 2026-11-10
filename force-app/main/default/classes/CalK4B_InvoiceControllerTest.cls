@IsTest
private class CalK4B_InvoiceControllerTest {
    static User rep() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        String key = String.valueOf(Crypto.getRandomInteger()).replace('-', '');
        User u = new User(Alias = 'ck4b', Email = 'ck4b' + key + '@example.invalid', EmailEncodingKey = 'UTF-8',
            LastName = 'CalK4BRep', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Chicago', Username = 'ck4b' + key + '@example.invalid');
        insert u;
        return u;
    }
    static void assign(User u, String permSet) {
        insert new PermissionSetAssignment(AssigneeId = u.Id,
            PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = :permSet].Id);
    }

    @IsTest
    static void systemModeQueryLeaksFieldWithoutFls() {
        User u = rep();
        assign(u, 'CalK4B_Sales_Rep');
        CalK4B_Invoice__c inv = new CalK4B_Invoice__c(Name = 'CalK4B-T065', Internal_Note__c = 'secret-note', OwnerId = u.Id);
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert inv;
        }
        CalK4B_Invoice__c leaked;
        Boolean describeAccessible;
        String userModeError;
        System.runAs(u) {
            describeAccessible = Schema.sObjectType.CalK4B_Invoice__c.fields.Internal_Note__c.isAccessible();
            leaked = CalK4B_InvoiceController.getInvoice(inv.Id);
            try {
                CalK4B_InvoiceController.getInvoiceUserMode(inv.Id);
            } catch (QueryException e) {
                userModeError = e.getMessage();
            }
            System.assertEquals(1, CalK4B_InvoiceController.listInvoices().size());
        }
        System.debug('CALK4B_T065 accessible=' + describeAccessible + ' leaked=' + leaked.Internal_Note__c + ' userModeError=' + userModeError);
        System.assertEquals(false, describeAccessible);
        System.assertEquals('secret-note', leaked.Internal_Note__c);
        System.assertNotEquals(null, userModeError);
    }
}