trigger CalK4A_DemoAccountTrigger on CalK4A_DemoAccount__c (before insert, before update) {
    CalK4A_DemoAccountTriggerHandler.beforeSave(Trigger.new);
}