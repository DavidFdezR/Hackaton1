public with sharing class CalK4A_DemoLeadRouter {
    @InvocableMethod(label='CalK4A Demo Route Lead')
    public static void route(List<Id> ids) {
        System.debug('CalK4A routing ' + ids.size());
    }
}