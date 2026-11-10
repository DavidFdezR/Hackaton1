trigger CalK1_DemoAccountTrigger on CalK1_DemoAccount__c (before insert, before update) {
    CalK1_DemoAccountTriggerHandler.handle(Trigger.new);
}