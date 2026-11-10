public with sharing class CalR_RenewalService {
    public static Boolean needsApproval(Decimal amount) {
        return CalR_DemoAccountTriggerHandler.classify(amount) == 'Large';
    }
}