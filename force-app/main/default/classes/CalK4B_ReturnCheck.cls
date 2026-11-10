public with sharing class CalK4B_ReturnCheck {
    public class Request {
        @InvocableVariable(label='Days since delivery' description='Whole days since delivery; do not guess missing information.' required=true)
        public Integer daysSinceDelivery;
        @InvocableVariable(label='Unopened' description='Whether the item is unopened, explicitly confirmed by the user.' required=true)
        public Boolean unopened;
    }
    public class Result {
        @InvocableVariable(label='Decision' description='ELIGIBLE, NOT_ELIGIBLE, or REVIEW under this example policy. No return is created.')
        public String decision;
        @InvocableVariable(label='Reason code' description='Reason for the decision; request missing information when REVIEW is returned.')
        public String reasonCode;
    }
    @InvocableMethod(label='Check sample return eligibility' description='Evaluate the sample 30-day unopened-item policy. Advisory only; creates no return and changes no records.')
    public static List<Result> evaluate(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null) {
            return results;
        }
        for (Request request : requests) {
            Result result = new Result();
            if (request == null || request.daysSinceDelivery == null || request.unopened == null) {
                result.decision = 'REVIEW';
                result.reasonCode = 'MISSING_INFORMATION';
            } else if (request.daysSinceDelivery < 0) {
                result.decision = 'REVIEW';
                result.reasonCode = 'INVALID_DELIVERY_AGE';
            } else if (request.daysSinceDelivery > 30) {
                result.decision = 'NOT_ELIGIBLE';
                result.reasonCode = 'OUTSIDE_RETURN_WINDOW';
            } else if (!request.unopened) {
                result.decision = 'NOT_ELIGIBLE';
                result.reasonCode = 'ITEM_OPENED';
            } else {
                result.decision = 'ELIGIBLE';
                result.reasonCode = 'WITHIN_WINDOW_AND_UNOPENED';
            }
            results.add(result);
        }
        return results;
    }
}