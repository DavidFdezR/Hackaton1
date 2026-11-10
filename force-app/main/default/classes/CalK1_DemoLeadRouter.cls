public with sharing class CalK1_DemoLeadRouter {
    public static String route(String state) {
        if (state == 'CA' || state == 'WA' || state == 'OR') {
            return 'West';
        }
        if (state == 'NY' || state == 'MA') {
            return 'East';
        }
        return 'Central';
    }
}