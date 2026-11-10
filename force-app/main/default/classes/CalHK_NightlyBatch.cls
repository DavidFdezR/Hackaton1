// B-219: scheduled nightly as 'CalHK Nightly Batch'. No-op over CalHK_Asset__c.
public with sharing class CalHK_NightlyBatch implements Database.Batchable<SObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) { return Database.getQueryLocator([SELECT Id FROM CalHK_Asset__c]); }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {}
    public void finish(Database.BatchableContext bc) {}
    public void execute(SchedulableContext sc) { Database.executeBatch(new CalHK_NightlyBatch()); }
}