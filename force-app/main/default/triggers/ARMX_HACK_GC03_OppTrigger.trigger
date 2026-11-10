trigger ARMX_HACK_GC03_OppTrigger on Opportunity (before insert, before update) {
    ARMX_HACK_GC03_OppStageHandler.apply(Trigger.new, Trigger.isInsert);
}