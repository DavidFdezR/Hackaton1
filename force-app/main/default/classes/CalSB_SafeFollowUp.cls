/** The safe twin: drafts a follow-up for a human to approve. Never sends; outsider text is quoted, links removed, instructions flagged. */
public with sharing class CalSB_SafeFollowUp {
    private static final Pattern SUSPICIOUS = Pattern.compile(
        '(?i)(https?://|\\bassistant\\b|\\bAI\\b|ignore (all|previous)|system note|you are now|post (this|a message)|slack|#general)');

    public class Draft {
        public String text;
        public Boolean flagged = false;
        public Boolean needsApproval = true;
    }

    public static Draft draftFor(Id leadId) {
        Lead l = [SELECT FirstName, LastName, Company, Description FROM Lead WHERE Id = :leadId];
        String notes = l.Description == null ? '' : l.Description;
        Draft d = new Draft();
        d.flagged = SUSPICIOUS.matcher(notes).find();
        String quoted = notes.replaceAll('(?i)https?://\\S+', '[link removed]').abbreviate(300);
        d.text = 'New lead ' + l.FirstName + ' ' + l.LastName + ' (' + l.Company + ').'
            + ' Prospect notes (untrusted, quoted): "' + quoted + '"'
            + (d.flagged ? ' [Flagged: the notes contain instructions or links; review before acting.]' : '');
        return d;
    }
}