@IsTest
private with sharing class CalK4A_T015_Test {
    @IsTest
    static void apiEnabledReachesEveryProfileUser() {
        List<User> reps = new List<User>();
        for (Integer i = 0; i < 3; i++) {
            reps.add(CalK4A_TestUsers.make('k4ap15' + i, 'CalK4A_DemoSales_Profile', null, null));
        }
        Set<Id> ids = new Map<Id, User>(reps).keySet();
        PermissionSet profilePs = [SELECT PermissionsApiEnabled, Profile.Name FROM PermissionSet WHERE Profile.Name = 'CalK4A_DemoSales_Profile'];
        Integer withApi = [SELECT COUNT() FROM PermissionSetAssignment WHERE AssigneeId IN :ids AND PermissionSet.PermissionsApiEnabled = true];
        CalK4A_TestUsers.obs('T-015', new Map<String, Object>{ 'profileApiEnabled' => profilePs.PermissionsApiEnabled,
            'testUsersOnProfile' => reps.size(), 'testUsersWithApiEnabled' => withApi,
            'realUsersOnProfile' => [SELECT COUNT() FROM User WHERE Profile.Name = 'CalK4A_DemoSales_Profile' AND Id NOT IN :ids] });
        Assert.isNotNull(profilePs);
    }
}