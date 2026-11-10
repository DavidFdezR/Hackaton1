trigger CalR_DemoAccountTrigger on CalR_DemoAccount__c (before insert, before update) {
    CalR_DemoAccountTriggerHandler.beforeSave(Trigger.new);
}