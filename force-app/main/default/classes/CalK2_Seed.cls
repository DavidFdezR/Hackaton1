public without sharing class CalK2_Seed {
    public static Integer run() {
        List<SObject> rows = new List<SObject>();
        for (Integer i = 1; i <= 3; i++) {
            rows.add(new CalK2_DemoAccount__c(Name = 'CalK2 Demo Acct ' + i));
            rows.add(new CalK2_DemoAcctTier__c(Name = 'CalK2 Demo Acct ' + i, Tier__c = 'Gold'));
            rows.add(new CalK2_DemoInvoice__c(Name = 'CalK2 INV-000' + i, Amount__c = 100 * i));
            rows.add(new CalK2_DemoInvoiceLab__c(Name = 'CalK2 INV-000' + i, Amount__c = 100 * i, Finance_Visible__c = (i != 3)));
            rows.add(new CalK2_DemoInvoicePRW__c(Name = 'CalK2 INV-000' + i, Amount__c = 100 * i));
        }
        rows.sort();
        insert rows;
        return rows.size();
    }
}