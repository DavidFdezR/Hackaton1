@isTest(SeeAllData=true)
private class TestAccountRecords {
    @isTest
    static void premiumAccountHasContacts() {
        Account premium = [SELECT Id, Name FROM Account WHERE Name = 'Cal Seeded Premium' LIMIT 1];
        Assert.isTrue(CalPremiumAccounts.contactCount(premium.Name) > 0);
    }
}