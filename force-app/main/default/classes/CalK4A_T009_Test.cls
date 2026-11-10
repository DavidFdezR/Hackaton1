@IsTest
private with sharing class CalK4A_T009_Test {
    @IsTest
    static void manualShareLostOnOwnerChangeApexReasonKept() {
        CalK4A_DemoProject__c manualProj = new CalK4A_DemoProject__c(Name = 'Manual-share project');
        CalK4A_DemoProject__c reasonProj = new CalK4A_DemoProject__c(Name = 'Apex-reason project');
        insert new List<CalK4A_DemoProject__c>{ manualProj, reasonProj };
        User member = CalK4A_TestUsers.make('k4amem1', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        User owner2 = CalK4A_TestUsers.make('k4aown2', 'Standard Platform User', null, new List<String>{ 'CalK4A_DemoRep_Base' });
        insert new List<CalK4A_DemoProject__Share>{
            new CalK4A_DemoProject__Share(ParentId = manualProj.Id, UserOrGroupId = member.Id, AccessLevel = 'Read',
                RowCause = Schema.CalK4A_DemoProject__Share.RowCause.Manual),
            new CalK4A_DemoProject__Share(ParentId = reasonProj.Id, UserOrGroupId = member.Id, AccessLevel = 'Read',
                RowCause = Schema.CalK4A_DemoProject__Share.RowCause.CalK4A_Project_Member__c)
        };
        Map<String, Object> o = new Map<String, Object>();
        o.put('before_shares', [SELECT Parent.Name, RowCause FROM CalK4A_DemoProject__Share WHERE UserOrGroupId = :member.Id]);
        o.put('before_memberAccess', CalK4A_TestUsers.access(member.Id, new Set<Id>{ manualProj.Id, reasonProj.Id }).values());
        update new List<CalK4A_DemoProject__c>{
            new CalK4A_DemoProject__c(Id = manualProj.Id, OwnerId = owner2.Id),
            new CalK4A_DemoProject__c(Id = reasonProj.Id, OwnerId = owner2.Id)
        };
        o.put('after_shares', [SELECT Parent.Name, RowCause FROM CalK4A_DemoProject__Share WHERE UserOrGroupId = :member.Id]);
        Map<Id, UserRecordAccess> acc = CalK4A_TestUsers.access(member.Id, new Set<Id>{ manualProj.Id, reasonProj.Id });
        o.put('after_memberReadManualProject', acc.get(manualProj.Id).HasReadAccess);
        o.put('after_memberReadReasonProject', acc.get(reasonProj.Id).HasReadAccess);
        CalK4A_TestUsers.obs('T-009', o);
        Assert.isFalse(acc.get(manualProj.Id).HasReadAccess);
    }
}