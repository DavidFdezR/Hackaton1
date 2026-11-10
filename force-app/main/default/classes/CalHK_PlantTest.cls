@isTest
private class CalHK_PlantTest {
    @isTest static void coversPlantedClasses() {
        insert new CalHK_Order__c(Name = 'CalHK Test Order', Status__c = 'New');
        insert new CalHK_Contract__c(Name = 'CalHK Test Contract', Status__c = 'Draft');
        CalHK_Order__c o = [SELECT Id FROM CalHK_Order__c LIMIT 1];
        System.assertEquals(125, CalHK_QuoteService.quote(100));
        System.assertEquals(100, CalHK_PricingApi.getPrice(o.Id));
        System.assertEquals('a / b', CalHK_InvoiceService.describe(' a', 'b '));
        System.assertEquals(18, CalHK_InvoiceService.calcTax(100));
        System.assertEquals(1, CalHK_AdminTools.getAllContracts().size());
        System.assertEquals(o.Id, CalHK_PublicController.getRecord(o.Id).Id);
        CalHK_OrderInvocable.stamp(new List<Id>{ o.Id });
        try { CalHK_InvoiceSelector.getInvoices(); } catch (Exception e) { System.debug('USER_MODE enforced: ' + e.getMessage()); }
        insert new CalHK_Project__c(Name = 'CalHK Test Project');
        Test.startTest(); Database.executeBatch(new CalHK_ProjectRecalc()); Test.stopTest();
    }
}