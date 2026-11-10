public with sharing class CalR_DealService {
    public static Boolean needsApproval(Decimal amount) {
        return CalR_DemoAccountTriggerHandler.classify(amount) == 'Large';
    }
}