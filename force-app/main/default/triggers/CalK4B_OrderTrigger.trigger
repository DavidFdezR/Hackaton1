trigger CalK4B_OrderTrigger on CalK4B_Order__c (after update) {
    List<CalK4B_OrderChanged__e> events = new List<CalK4B_OrderChanged__e>();
    for (CalK4B_Order__c o : Trigger.new) {
        events.add(new CalK4B_OrderChanged__e(OrderId__c = o.Id));
    }
    EventBus.publish(events);
}