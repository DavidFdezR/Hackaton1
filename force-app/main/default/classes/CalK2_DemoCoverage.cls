public with sharing class CalK2_DemoCoverage {
    public static Integer score(Integer a, Integer b) {
        Integer total = 0;
        total += a;
        total += b;
        total += 1;
        total += 2;
        total += 3;
        total += 4;
        total += 5;
        total += 6;
        total += 7;
        total += 8;
        total += 9;
        total += 10;
        total += 11;
        if (a < 0) {
            total = -1;
            total += 1;
            total += 2;
            total += 3;
        }
        return total;
    }
}