@IsTest
private class CalK1_DemoInvoiceControllerTest {
    @TestSetup
    static void plant() {
        List<CalK1_DemoInvoice__c> rows = new List<CalK1_DemoInvoice__c>();
        for (Integer i = 0; i < 3; i++) {
            rows.add(new CalK1_DemoInvoice__c(Name = 'CalK1 inv ' + i, Open__c = true, Amount__c = 100 + i));
        }
        insert rows;
    }

    static User lowPrivilegeUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String u = 'calk1.rep' + Crypto.getRandomInteger() + '@example.invalid';
        return new User(Username = u, Email = u, LastName = 'CalK1Rep', Alias = 'calk1r', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
    }

    @IsTest
    static void ownerSeesOwnInvoices() {
        System.assertEquals(3, CalK1_DemoInvoiceController.getMyOpenInvoices().size());
    }

    @IsTest
    static void otherUserSeesNoneWithSharing() {
        User rep = lowPrivilegeUser();
        insert rep;
        System.runAs(rep) {
            System.assertEquals(0, CalK1_DemoInvoiceController.getMyOpenInvoices().size());
        }
    }
}