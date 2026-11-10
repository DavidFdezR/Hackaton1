@IsTest
private with sharing class CalK4A_T022_Test {
    static Map<String, Object> read(User u, Id recId) {
        Map<String, Object> r = new Map<String, Object>();
        System.runAs(u) {
            try {
                SObject a = Database.query('SELECT Demo_SSN__c, Demo_Card__c FROM CalK4A_DemoAccount__c WHERE Id = \'' + recId + '\' WITH USER_MODE');
                r.put('ssn', a.get('Demo_SSN__c'));
                r.put('card', a.get('Demo_Card__c'));
            } catch (Exception e) {
                r.put('error', e.getMessage().left(160));
            }
        }
        return r;
    }

    @IsTest
    static void viewEncryptedDataScope() {
        CalK4A_DemoAccount__c a = new CalK4A_DemoAccount__c(Name = 'Encrypted demo', Tier__c = 'Gold');
        a.put('Demo_SSN__c', '000-00-1234');
        a.put('Demo_Card__c', '4111111111111111');
        insert a;
        User support = CalK4A_TestUsers.make('k4asup1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoSupport_Read' });
        Map<String, Object> o = new Map<String, Object>();
        o.put('before', read(support, a.Id));
        PermissionSet ved = CalK4A_Probe.permSet('CalK4A_T022_VED', new List<String>{ 'ViewEncryptedData' });
        System.runAs(new User(Id = UserInfo.getUserId())) {
            o.put('saveViewEncryptedDataAlone', CalK4A_Probe.tryInsert(ved));
            insert new PermissionSetAssignment(AssigneeId = support.Id, PermissionSetId = ved.Id);
        }
        o.put('after', read(support, a.Id));
        o.put('permissionIsSystemLevel', Schema.SObjectType.PermissionSet.fields.getMap().containsKey('permissionsviewencrypteddata'));
        o.put('encryptedFieldsOnObject', new List<String>{
            String.valueOf(Schema.SObjectType.CalK4A_DemoAccount__c.fields.getMap().get('Demo_SSN__c').getDescribe().isEncrypted()),
            String.valueOf(Schema.SObjectType.CalK4A_DemoAccount__c.fields.getMap().get('Demo_Card__c').getDescribe().isEncrypted()) });
        CalK4A_TestUsers.obs('T-022', o);
        Assert.isNotNull(o.get('after'));
    }
}