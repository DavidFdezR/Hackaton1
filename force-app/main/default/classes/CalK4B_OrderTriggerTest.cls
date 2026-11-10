@IsTest
private class CalK4B_OrderTriggerTest {
    @IsTest
    static void publishesOnUpdate() {
        CalK4B_Order__c o = new CalK4B_Order__c(Name = 'CalK4B-ORD-T');
        insert o;
        Test.startTest();
        o.Status__c = 'Changed';
        update o;
        Test.stopTest();
        System.assertEquals('Changed', [SELECT Status__c FROM CalK4B_Order__c WHERE Id = :o.Id].Status__c);
    }
}