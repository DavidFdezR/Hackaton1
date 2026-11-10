@IsTest
public class CalK4A_TestUsers {
    static Integer seq = 0;

    public static User make(String alias, String profileName, String roleDevName, List<String> psNames) {
        User u;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Id roleId = roleDevName == null ? null : [SELECT Id FROM UserRole WHERE DeveloperName = :roleDevName].Id;
            u = new User(Alias = alias.left(8), Email = alias + '@calk4a.example',
                Username = alias + '.' + (seq++) + '.' + Datetime.now().getTime() + '@calk4a.example',
                LastName = 'CalK4A ' + alias, ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
                UserRoleId = roleId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
            insert u;
            assign(u.Id, psNames);
        }
        return u;
    }

    public static void assign(Id userId, List<String> psNames) {
        if (psNames == null || psNames.isEmpty()) {
            return;
        }
        List<PermissionSetAssignment> rows = new List<PermissionSetAssignment>();
        for (PermissionSet ps : [SELECT Id FROM PermissionSet WHERE Name IN :psNames]) {
            rows.add(new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id));
        }
        insert rows;
    }

    public static Map<Id, UserRecordAccess> access(Id userId, Set<Id> recordIds) {
        Map<Id, UserRecordAccess> byRecord = new Map<Id, UserRecordAccess>();
        for (UserRecordAccess a : [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, MaxAccessLevel
                                   FROM UserRecordAccess WHERE UserId = :userId AND RecordId IN :recordIds]) {
            byRecord.put(a.RecordId, a);
        }
        return byRecord;
    }

    public static String owd(String objectName) {
        return [SELECT InternalSharingModel FROM EntityDefinition WHERE QualifiedApiName = :objectName].InternalSharingModel;
    }

    public static void obs(String key, Object value) {
        System.debug(LoggingLevel.ERROR, 'CALK4A_OBS ' + key + '=' + JSON.serialize(value));
    }
}