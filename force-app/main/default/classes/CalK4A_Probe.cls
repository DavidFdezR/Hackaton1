@IsTest
public class CalK4A_Probe {
    public static String tryUpdate(SObject rec) {
        try {
            Database.update(rec, AccessLevel.USER_MODE);
            return 'saved';
        } catch (Exception e) {
            return e.getMessage().left(160);
        }
    }

    public static String tryInsert(SObject rec) {
        try {
            insert rec;
            return 'saved';
        } catch (Exception e) {
            return e.getMessage().left(220);
        }
    }

    public static String tryUpdateSystem(SObject rec) {
        try {
            update rec;
            return 'saved';
        } catch (Exception e) {
            return e.getMessage().left(220);
        }
    }

    public static PermissionSet permSet(String name, List<String> perms) {
        PermissionSet ps = new PermissionSet(Name = name, Label = name.replace('_', ' '));
        for (String p : perms) {
            ps.put('Permissions' + p, true);
        }
        return ps;
    }

    public static Map<String, Object> fieldPerm(String psName, String field) {
        List<FieldPermissions> fps = [SELECT PermissionsRead, PermissionsEdit FROM FieldPermissions
                                      WHERE Parent.Name = :psName AND Field = :field];
        return fps.isEmpty() ? new Map<String, Object>{ 'row' => 'none (no access)' }
            : new Map<String, Object>{ 'read' => fps[0].PermissionsRead, 'edit' => fps[0].PermissionsEdit };
    }
}