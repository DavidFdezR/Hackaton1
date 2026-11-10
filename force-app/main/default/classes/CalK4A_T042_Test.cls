@IsTest
private class CalK4A_T042_Test {
    @IsTest
    static void factoryInsertOfActiveAccountWithoutTier() {
        String outcome;
        try {
            insert new CalK4A_DemoAccount__c(Name = 'Factory account', Status__c = 'Active');
            outcome = 'saved';
        } catch (DmlException e) {
            outcome = e.getDmlType(0) + ': ' + e.getDmlMessage(0);
        }
        CalK4A_TestUsers.obs('T-042', new Map<String, Object>{ 'activeWithoutTier' => outcome });
        Assert.isNotNull(outcome);
    }
}