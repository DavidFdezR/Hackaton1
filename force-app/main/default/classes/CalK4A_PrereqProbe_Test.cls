@IsTest
private class CalK4A_PrereqProbe_Test {
    static final List<String> PERMS = new List<String>{
        'PermissionsModifyAllData', 'PermissionsAuthorApex', 'PermissionsCustomizeApplication', 'PermissionsManageUsers',
        'PermissionsViewEncryptedData', 'PermissionsResetPasswords', 'PermissionsApiEnabled', 'PermissionsViewAllData'
    };

    @IsTest
    static void eachPermissionAloneOnAPermissionSet() {
        Map<String, String> outcome = new Map<String, String>();
        Integer i = 0;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            for (String perm : PERMS) {
                PermissionSet ps = new PermissionSet(Name = 'CalK4A_Probe_' + (i++), Label = 'CalK4A Probe ' + i);
                ps.put(perm, true);
                Savepoint sp = Database.setSavepoint();
                try {
                    insert ps;
                    PermissionSet saved = (PermissionSet) Database.query('SELECT ' + String.join(PERMS, ',') + ' FROM PermissionSet WHERE Id = \'' + ps.Id + '\'');
                    List<String> enabled = new List<String>();
                    for (String p : PERMS) {
                        if (saved.get(p) == true) {
                            enabled.add(p);
                        }
                    }
                    outcome.put(perm, 'ACCEPTED; enabled after save: ' + String.join(enabled, ','));
                } catch (Exception e) {
                    outcome.put(perm, 'REFUSED: ' + e.getMessage());
                }
                Database.rollback(sp);
            }
        }
        CalK4A_TestUsers.obs('PREREQ', outcome);
        Assert.areEqual(PERMS.size(), outcome.size());
    }
}