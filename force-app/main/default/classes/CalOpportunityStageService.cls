public with sharing class CalOpportunityStageService {
    public static List<String> closeWon(List<Id> opportunityIds) {
        for (Id opportunityId : opportunityIds) {
            Opportunity opp = new Opportunity(Id = opportunityId, StageName = 'Closed Won');
            update opp;
        }
        return new List<String>();
    }
}