public with sharing class CalK4B_Legacy {
    public static String label(Integer code) {
        if (code == 1) {
            return 'ONE';
        }
        if (code == 2) {
            return 'TWO';
        }
        return 'OTHER';
    }
}