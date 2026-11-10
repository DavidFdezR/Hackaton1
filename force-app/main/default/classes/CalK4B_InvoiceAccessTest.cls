@IsTest
private class CalK4B_InvoiceAccessTest {
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

    static Id invoiceOwnedBy(User u) {
        CalK4B_Invoice__c inv = new CalK4B_Invoice__c(Name = 'CalK4B-T053', Promo_Code__c = 'P1', OwnerId = u.Id);
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert inv;
        }
        return inv.Id;
    }
    @IsTest
    static void userModeQueryFailsWithoutFls() {
        User u = rep();
        assign(u, 'CalK4B_Sales_Rep');
        Id invId = invoiceOwnedBy(u);
        String error;
        System.runAs(u) {
            try {
                CalK4B_InvoiceService.promoCodes(new Set<Id>{invId});
            } catch (QueryException e) {
                error = e.getMessage();
            }
        }
        System.debug('CALK4B_T053_ERROR ' + error);
        System.assertNotEquals(null, error);
        System.assert(error.contains('Promo_Code__c'), error);
    }
    @IsTest
    static void grantingFlsMakesItPass() {
        User u = rep();
        assign(u, 'CalK4B_Sales_Rep');
        insert new FieldPermissions(ParentId = [SELECT Id FROM PermissionSet WHERE Name = 'CalK4B_Sales_Rep'].Id,
            SobjectType = 'CalK4B_Invoice__c', Field = 'CalK4B_Invoice__c.Promo_Code__c',
            PermissionsRead = true, PermissionsEdit = true);
        Id invId = invoiceOwnedBy(u);
        List<CalK4B_Invoice__c> rows;
        System.runAs(u) {
            rows = CalK4B_InvoiceService.promoCodes(new Set<Id>{invId});
        }
        System.assertEquals('P1', rows[0].Promo_Code__c);
    }
}