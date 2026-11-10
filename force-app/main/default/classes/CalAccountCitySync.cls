public with sharing class CalAccountCitySync {
    public static void copyCity(List<Account> accounts, Map<Id, Account> previous) {
        for (Account a : accounts) {
            if (a.BillingCity != previous.get(a.Id).BillingCity) {
                for (Contact c : [SELECT Id FROM Contact WHERE AccountId = :a.Id]) {
                    c.MailingCity = a.BillingCity;
                    update c;
                }
            }
        }
    }
}