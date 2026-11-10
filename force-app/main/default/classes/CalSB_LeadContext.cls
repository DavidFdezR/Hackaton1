/** What an AI agent would be grounded on for a lead. Company, Email and Description come straight from the public Web-to-Lead form. */
public with sharing class CalSB_LeadContext {
    public static String forLead(Id leadId) {
        Lead l = [SELECT FirstName, LastName, Company, Email, LeadSource, Description FROM Lead WHERE Id = :leadId];
        return 'Lead: ' + l.FirstName + ' ' + l.LastName
            + '\nCompany: ' + l.Company
            + '\nEmail: ' + l.Email
            + '\nSource: ' + l.LeadSource
            + '\nNotes from the prospect: ' + l.Description;
    }
}