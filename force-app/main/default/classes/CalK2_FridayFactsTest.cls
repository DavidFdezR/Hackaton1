@isTest
private class CalK2_FridayFactsTest {
    static Integer seq = 0;

    static User newUser(String alias) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce'];
        seq++;
        User u = new User(Alias = alias, LastName = 'CalK2 ' + alias, Email = alias + '@example.com',
            Username = 'calk2.' + alias + seq + '.' + System.now().getTime() + '@example.com',
            ProfileId = p.Id, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        insert u;
        return u;
    }

    static PermissionSet permSet(String name) {
        PermissionSet ps = new PermissionSet(Name = name, Label = name);
        insert ps;
        return ps;
    }

    static void objectAccess(Id psId, String sobjectType, Boolean edit) {
        insert new ObjectPermissions(ParentId = psId, SobjectType = sobjectType, PermissionsRead = true,
            PermissionsEdit = edit, PermissionsCreate = false, PermissionsDelete = false,
            PermissionsViewAllRecords = false, PermissionsModifyAllRecords = false);
    }

    static void assign(Id psId, Id userId) {
        insert new PermissionSetAssignment(PermissionSetId = psId, AssigneeId = userId);
    }

    static void log(String caseId, String msg) {
        System.debug(LoggingLevel.ERROR, 'CALK2|' + caseId + '|' + msg);
    }

    @isTest
    static void f003FieldEditWithoutObjectAccessIsRejected() {
        PermissionSet ps = permSet('CalK2_T_FieldOnly');
        String outcome;
        try {
            insert new FieldPermissions(ParentId = ps.Id, SobjectType = 'CalK2_DemoAccount__c',
                Field = 'CalK2_DemoAccount__c.Region__c', PermissionsRead = true, PermissionsEdit = true);
            outcome = 'ACCEPTED';
        } catch (DmlException e) {
            outcome = 'REJECTED: ' + e.getDmlStatusCode(0) + ' ' + e.getDmlMessage(0);
        }
        log('F-003', 'FieldPermissions Read+Edit insert without ObjectPermissions -> ' + outcome);
        if (outcome == 'ACCEPTED') {
            User u = newUser('f003z');
            assign(ps.Id, u.Id);
            System.runAs(u) {
                String r;
                try {
                    r = 'sees ' + [SELECT COUNT() FROM CalK2_DemoAccount__c WITH USER_MODE] + ' record(s)';
                } catch (Exception e) {
                    r = 'query FAILED: ' + e.getMessage();
                }
                log('F-003', 'field-only permset user: object isAccessible=' + Schema.sObjectType.CalK2_DemoAccount__c.isAccessible()
                    + ', Region__c isUpdateable=' + Schema.sObjectType.CalK2_DemoAccount__c.fields.Region__c.isUpdateable() + ', ' + r);
            }
        }
    }

    @isTest
    static void f003FieldEditNeedsObjectEdit() {
        User u = newUser('f003a');
        Id recId;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet ps = permSet('CalK2_T_SalesRead');
            objectAccess(ps.Id, 'CalK2_DemoAccount__c', false);
            insert new FieldPermissions(ParentId = ps.Id, SobjectType = 'CalK2_DemoAccount__c',
                Field = 'CalK2_DemoAccount__c.Region__c', PermissionsRead = true, PermissionsEdit = true);
            assign(ps.Id, u.Id);
        }
        CalK2_DemoAccount__c a = new CalK2_DemoAccount__c(Name = 'F003', OwnerId = u.Id);
        insert a;
        System.runAs(u) {
            Boolean fieldUpdateable = Schema.sObjectType.CalK2_DemoAccount__c.fields.Region__c.isUpdateable();
            String result;
            try {
                update as user new CalK2_DemoAccount__c(Id = a.Id, Region__c = 'EMEA');
                result = 'UPDATED';
            } catch (Exception e) {
                result = 'FAILED: ' + e.getMessage();
            }
            log('F-003', 'object Read only + field Edit: describe isUpdateable=' + fieldUpdateable + ', update as user -> ' + result);
            System.assert(result.startsWith('FAILED'), result);
        }
    }

    @isTest
    static void f003FieldEditWorksWithObjectReadEdit() {
        User u = newUser('f003b');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet ps = permSet('CalK2_T_SalesEdit');
            objectAccess(ps.Id, 'CalK2_DemoAccount__c', true);
            insert new FieldPermissions(ParentId = ps.Id, SobjectType = 'CalK2_DemoAccount__c',
                Field = 'CalK2_DemoAccount__c.Region__c', PermissionsRead = true, PermissionsEdit = true);
            assign(ps.Id, u.Id);
        }
        CalK2_DemoAccount__c a = new CalK2_DemoAccount__c(Name = 'F003b', OwnerId = u.Id);
        insert a;
        System.runAs(u) {
            update as user new CalK2_DemoAccount__c(Id = a.Id, Region__c = 'EMEA');
            log('F-003', 'object Read+Edit + field Read+Edit: update as user -> UPDATED, isUpdateable='
                + Schema.sObjectType.CalK2_DemoAccount__c.fields.Region__c.isUpdateable());
        }
    }

    static List<CalK2_DemoInvoiceLab__c> labInvoices() {
        List<CalK2_DemoInvoiceLab__c> rows = new List<CalK2_DemoInvoiceLab__c>{
            new CalK2_DemoInvoiceLab__c(Name = 'L1', Finance_Visible__c = true),
            new CalK2_DemoInvoiceLab__c(Name = 'L2', Finance_Visible__c = true),
            new CalK2_DemoInvoiceLab__c(Name = 'L3', Finance_Visible__c = false)
        };
        insert rows;
        return rows;
    }

    @isTest
    static void f014ReadOnlySharingRulePlusObjectRead() {
        User member = newUser('f14m');
        User outsider = newUser('f14o');
        User memberNoObj = newUser('f14n');
        Id financeGroup = [SELECT Id FROM Group WHERE DeveloperName = 'CalK2_Demo_Finance_Team'].Id;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet ps = permSet('CalK2_T_InvRead');
            objectAccess(ps.Id, 'CalK2_DemoInvoiceLab__c', true);
            assign(ps.Id, member.Id);
            assign(ps.Id, outsider.Id);
            insert new List<GroupMember>{
                new GroupMember(GroupId = financeGroup, UserOrGroupId = member.Id),
                new GroupMember(GroupId = financeGroup, UserOrGroupId = memberNoObj.Id)
            };
        }
        List<CalK2_DemoInvoiceLab__c> rows = labInvoices();
        for (CalK2_DemoInvoiceLab__Share sh : [SELECT ParentId, UserOrGroupId, AccessLevel, RowCause FROM CalK2_DemoInvoiceLab__Share WHERE ParentId IN :rows]) {
            log('F-014', 'share row: parent=' + sh.ParentId + ' toFinanceGroup=' + (sh.UserOrGroupId == financeGroup) + ' level=' + sh.AccessLevel + ' cause=' + sh.RowCause);
        }
        log('F-014', 'GroupMember rows for finance group=' + [SELECT COUNT() FROM GroupMember WHERE GroupId = :financeGroup]);
        Integer memberSees;
        String memberEdit;
        System.runAs(member) {
            memberSees = [SELECT COUNT() FROM CalK2_DemoInvoiceLab__c WITH USER_MODE];
            UserRecordAccess ura = [SELECT RecordId, HasReadAccess, HasEditAccess FROM UserRecordAccess
                WHERE UserId = :member.Id AND RecordId = :rows[0].Id];
            try {
                update as user new CalK2_DemoInvoiceLab__c(Id = rows[0].Id, Name = 'edited');
                memberEdit = 'UPDATED';
            } catch (Exception e) {
                memberEdit = 'FAILED: ' + e.getMessage();
            }
            log('F-014', 'finance member (object Read+Edit via permset, Read via rule): sees ' + memberSees
                + ' of 3, HasRead=' + ura.HasReadAccess + ' HasEdit=' + ura.HasEditAccess + ', update -> ' + memberEdit);
        }
        Integer outsiderSees;
        System.runAs(outsider) {
            outsiderSees = [SELECT COUNT() FROM CalK2_DemoInvoiceLab__c WITH USER_MODE];
            log('F-014', 'non-member with same permset: sees ' + outsiderSees + ' of 3');
        }
        String noObj;
        System.runAs(memberNoObj) {
            try {
                noObj = 'sees ' + [SELECT COUNT() FROM CalK2_DemoInvoiceLab__c WITH USER_MODE];
            } catch (Exception e) {
                noObj = 'query FAILED: ' + e.getMessage();
            }
            log('F-014', 'finance member with no object Read: ' + noObj);
        }
        log('F-014', 'test-context: criteria rule shares were not created for test-inserted rows; see org-data method');
    }

    @isTest(SeeAllData=true)
    static void f014OrgRecordsWithCriteriaRule() {
        User member = newUser('f14x');
        User outsider = newUser('f14y');
        Id financeGroup = [SELECT Id FROM Group WHERE DeveloperName = 'CalK2_Demo_Finance_Team'].Id;
        PermissionSet ps = permSet('CalK2_T_InvRead2');
        objectAccess(ps.Id, 'CalK2_DemoInvoiceLab__c', true);
        assign(ps.Id, member.Id);
        assign(ps.Id, outsider.Id);
        insert new GroupMember(GroupId = financeGroup, UserOrGroupId = member.Id);
        Integer total = [SELECT COUNT() FROM CalK2_DemoInvoiceLab__c];
        System.runAs(member) {
            List<CalK2_DemoInvoiceLab__c> seen = [SELECT Id FROM CalK2_DemoInvoiceLab__c WITH USER_MODE];
            String edit = 'n/a';
            if (!seen.isEmpty()) {
                UserRecordAccess ura = [SELECT RecordId, HasReadAccess, HasEditAccess FROM UserRecordAccess
                    WHERE UserId = :member.Id AND RecordId = :seen[0].Id];
                edit = 'HasRead=' + ura.HasReadAccess + ' HasEdit=' + ura.HasEditAccess;
                try {
                    update as user new CalK2_DemoInvoiceLab__c(Id = seen[0].Id, Name = 'edited');
                    edit += ', update -> UPDATED';
                } catch (Exception e) {
                    edit += ', update -> FAILED: ' + e.getMessage();
                }
            }
            log('F-014', 'org data: finance member with object Read+Edit permset sees ' + seen.size() + ' of ' + total + ' (' + edit + ')');
        }
        System.runAs(outsider) {
            log('F-014', 'org data: non-member with same permset sees ' + [SELECT COUNT() FROM CalK2_DemoInvoiceLab__c WITH USER_MODE] + ' of ' + total);
        }
    }

    @isTest
    static void f021PublicReadWriteGrantsEditToAnyoneWithObjectAccess() {
        User anyUser = newUser('f21a');
        User noObjUser = newUser('f21n');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet ps = permSet('CalK2_T_PrwEdit');
            objectAccess(ps.Id, 'CalK2_DemoInvoicePRW__c', true);
            objectAccess(ps.Id, 'CalK2_DemoInvoice__c', true);
            assign(ps.Id, anyUser.Id);
        }
        CalK2_DemoInvoicePRW__c prw = new CalK2_DemoInvoicePRW__c(Name = 'PRW1');
        insert prw;
        insert new CalK2_DemoInvoice__c(Name = 'PRIV1');
        System.runAs(anyUser) {
            Integer seesPrw = [SELECT COUNT() FROM CalK2_DemoInvoicePRW__c WITH USER_MODE];
            update as user new CalK2_DemoInvoicePRW__c(Id = prw.Id, Name = 'edited by non-owner');
            Integer seesPrivate = [SELECT COUNT() FROM CalK2_DemoInvoice__c WITH USER_MODE];
            log('F-021', 'non-owner, no group, object Read+Edit: Public Read/Write object sees ' + seesPrw
                + ' and update -> UPDATED; Private object sees ' + seesPrivate);
            System.assertEquals(1, seesPrw);
            System.assertEquals(0, seesPrivate);
        }
        System.runAs(noObjUser) {
            String r;
            try {
                r = 'sees ' + [SELECT COUNT() FROM CalK2_DemoInvoicePRW__c WITH USER_MODE];
            } catch (Exception e) {
                r = 'query FAILED: ' + e.getMessage();
            }
            log('F-021', 'user with no object permission on Public Read/Write object: ' + r);
        }
    }

    without sharing class NoSharingLookup {
        CalK2_DemoInvoice__c find(Id invoiceId) {
            List<CalK2_DemoInvoice__c> rows = [SELECT Id, Name FROM CalK2_DemoInvoice__c WHERE Id = :invoiceId];
            return rows.isEmpty() ? null : rows[0];
        }
    }

    @isTest
    static void f023WithSharingThrowsWithoutSharingLeaks() {
        User reader = newUser('f23r');
        User stranger = newUser('f23s');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet ps = permSet('CalK2_T_InvCtl');
            objectAccess(ps.Id, 'CalK2_DemoInvoice__c', false);
            assign(ps.Id, reader.Id);
        }
        CalK2_DemoInvoice__c inv = new CalK2_DemoInvoice__c(Name = 'INV-F023');
        insert inv;
        System.runAs(reader) {
            String r;
            try {
                CalK2_DemoInvoiceController.getInvoice(inv.Id);
                r = 'returned record';
            } catch (AuraHandledException e) {
                r = 'AuraHandledException (record not found branch)';
            }
            log('F-023', 'with sharing controller as reader (object Read, no share) -> ' + r);
            System.assert(r.startsWith('AuraHandledException'), r);
            log('F-023', 'without sharing lookup as reader -> ' + (new NoSharingLookup().find(inv.Id) != null ? 'RECORD RETURNED' : 'null'));
        }
        System.runAs(stranger) {
            log('F-023', 'without sharing lookup as user with NO object permission -> '
                + (new NoSharingLookup().find(inv.Id) != null ? 'RECORD RETURNED' : 'null'));
        }
        insert new CalK2_DemoInvoice__Share(ParentId = inv.Id, UserOrGroupId = reader.Id, AccessLevel = 'Read', RowCause = 'Manual');
        System.runAs(reader) {
            log('F-023', 'with sharing controller after adding a Read share for reader -> ' + CalK2_DemoInvoiceController.getInvoice(inv.Id).Name);
        }
    }

    @isTest
    static void f024QueueNeedsSupportedObjectNotMembers() {
        Group noObjects = [SELECT Id FROM Group WHERE DeveloperName = 'CalK2_Demo_Support_Queue' AND Type = 'Queue'];
        Group caseNoMembers = [SELECT Id FROM Group WHERE DeveloperName = 'CalK2_Demo_Case_Queue_NoMembers' AND Type = 'Queue'];
        log('F-024', 'Support queue members=' + [SELECT COUNT() FROM GroupMember WHERE GroupId = :noObjects.Id]
            + ', QueueSobject rows=' + [SELECT COUNT() FROM QueueSobject WHERE QueueId = :noObjects.Id]
            + '; NoMembers queue members=' + [SELECT COUNT() FROM GroupMember WHERE GroupId = :caseNoMembers.Id]
            + ', QueueSobject=' + [SELECT SobjectType FROM QueueSobject WHERE QueueId = :caseNoMembers.Id].SobjectType);
        Case c = new Case(Subject = 'CalK2 Demo queue test');
        insert c;
        String r1;
        try {
            update new Case(Id = c.Id, OwnerId = noObjects.Id);
            r1 = 'ASSIGNED';
        } catch (DmlException e) {
            r1 = 'REJECTED: ' + e.getDmlStatusCode(0) + ' ' + e.getDmlMessage(0);
        }
        log('F-024', 'Case owner -> queue with member but no Supported Objects: ' + r1);
        update new Case(Id = c.Id, OwnerId = caseNoMembers.Id);
        log('F-024', 'Case owner -> queue with Case supported and zero members: ASSIGNED');
        System.assert(r1.startsWith('REJECTED'), r1);
    }
}