trigger CalK4A_DemoAccountAudit on CalK4A_DemoAccount__c (before update) {
    for (CalK4A_DemoAccount__c row : Trigger.new) {
        row.Notes2__c = 'audit region=' + row.Region__c;
    }
}