// T-211 / F-106: Apex sharing recalculation batch for CalHK_Project__c.
public with sharing class CalHK_ProjectRecalc implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) { return Database.getQueryLocator([SELECT Id FROM CalHK_Project__c]); }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {}
    public void finish(Database.BatchableContext bc) {}
}