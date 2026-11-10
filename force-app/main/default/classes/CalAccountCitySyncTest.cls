@isTest
private class CalAccountCitySyncTest {
    @isTest
    static void bulkCityChangeStaysWithinLimits() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Cal City ' + i, BillingCity = 'Austin'));
        }
        insert accounts;
        List<Contact> contacts = new List<Contact>();
        for (Account a : accounts) {
            contacts.add(new Contact(LastName = 'Resident', AccountId = a.Id, MailingCity = 'Austin'));
        }
        insert contacts;
        for (Account a : accounts) {
            a.BillingCity = 'Denver';
        }
        Test.startTest();
        update accounts;
        Integer queries = Limits.getQueries();
        Integer dml = Limits.getDmlStatements();
        Test.stopTest();
        Assert.isTrue(queries <= 3, 'Queries used: ' + queries);
        Assert.isTrue(dml <= 3, 'DML statements used: ' + dml);
        Assert.areEqual(200, [SELECT COUNT() FROM Contact WHERE MailingCity = 'Denver']);
    }
}