public inherited sharing class CalK4A_DemoMoneyUtil implements Queueable {
    public static Integer countInvoices() {
        return [SELECT COUNT() FROM CalK4A_DemoInvoice__c];
    }

    public void execute(QueueableContext ctx) {
        insert new CalK4A_DemoKnowledgeTip__c(Name = 'CalK4A_T006_entrypoint_count=' + countInvoices());
    }
}