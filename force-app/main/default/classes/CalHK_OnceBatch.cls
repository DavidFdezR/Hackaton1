// B-220: run once with Database.executeBatch, never scheduled.
public with sharing class CalHK_OnceBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) { return Database.getQueryLocator([SELECT Id FROM CalHK_Asset__c]); }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {}
    public void finish(Database.BatchableContext bc) {}
}