/**
 * ARMX golden case 03 - synthetic automation conflict.
 * Forces StageName = Qualification on Opportunities whose Name starts with ARMX_HACK_GC03_.
 * Runs only in before-save context: no DML, so it cannot recurse on its own. It is re-entered only
 * when something else (the ARMX_HACK_GC03 Flow) updates the same record in the same transaction.
 */
public with sharing class ARMX_HACK_GC03_OppStageHandler {
    public static final String NAME_PREFIX = 'ARMX_HACK_GC03_';
    public static final String FORCED_STAGE = 'Qualification';
    @TestVisible static Integer runCount = 0;

    public static void apply(List<Opportunity> opps, Boolean isInsert) {
        runCount++;
        for (Opportunity o : opps) {
            if (o.Name == null || !o.Name.startsWith(NAME_PREFIX)) {
                continue;
            }
            System.debug(LoggingLevel.INFO, 'ARMX_GC03 TRIGGER run=' + runCount
                + ' ctx=' + (isInsert ? 'beforeInsert' : 'beforeUpdate')
                + ' stageIn=' + o.StageName + ' stageOut=' + FORCED_STAGE);
            o.StageName = FORCED_STAGE;
        }
    }
}