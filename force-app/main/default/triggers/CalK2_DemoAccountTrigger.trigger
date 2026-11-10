trigger CalK2_DemoAccountTrigger on CalK2_DemoAccount__c (before insert, before update) {
    CalK2_DemoAccountTriggerHandler.handleBefore(Trigger.new);
}