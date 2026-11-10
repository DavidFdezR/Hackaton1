@IsTest
private class CalR_DemoAccountTriggerHandlerTest {
    @IsTest
    static void classifiesByAmount() {
        System.assertEquals('Unknown', CalR_DemoAccountTriggerHandler.classify(null));
        System.assertEquals('Small', CalR_DemoAccountTriggerHandler.classify(5000));
        System.assertEquals('Large', CalR_DemoAccountTriggerHandler.classify(250000));
    }

    @IsTest
    static void triggerSetsTier() {
        Profile standard = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String unique = 'calrw' + String.valueOf(Crypto.getRandomInteger()).replace('-', '') + '@calr.example';
        User writer = new User(Alias = 'calrw', LastName = 'CalR Writer', Email = unique, Username = unique,
            ProfileId = standard.Id, TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert writer;
            insert new PermissionSetAssignment(AssigneeId = writer.Id,
                PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'CalR_DemoAccount_Writer'].Id);
        }
        CalR_DemoAccount__c account = new CalR_DemoAccount__c(Name = 'CalR Demo Acme', Amount__c = 250000);
        System.runAs(writer) {
            insert account;
            System.assertEquals('Large', [SELECT Tier__c FROM CalR_DemoAccount__c WHERE Id = :account.Id].Tier__c);
        }
    }
}