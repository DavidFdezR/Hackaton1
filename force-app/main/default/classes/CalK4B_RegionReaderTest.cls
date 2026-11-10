@IsTest
private class CalK4B_RegionReaderTest {
    @IsTest
    static void readsRegion() {
        CalK4B_Account__c a = new CalK4B_Account__c(Name = 'CalK4B-R', Tier__c = 'Gold', Region__c = 'EMEA');
        insert a;
        System.assertEquals('EMEA', CalK4B_RegionReader.regionOf(a.Id));
    }
}