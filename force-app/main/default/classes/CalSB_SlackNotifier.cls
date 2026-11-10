/** The risky agent action: posts whatever the agent decides to an internal Slack channel, under whatever name it picks. */
public with sharing class CalSB_SlackNotifier {
    public class Request {
        @InvocableVariable(required=true label='Channel') public String channel;
        @InvocableVariable(required=true label='Post as') public String postAs;
        @InvocableVariable(required=true label='Message') public String text;
    }

    @InvocableMethod(label='Post follow-up to Slack' description='Agent action: posts a message to an internal Slack channel')
    public static List<Integer> post(List<Request> requests) {
        List<Integer> statuses = new List<Integer>();
        for (Request r : requests) {
            statuses.add(send(r));
        }
        return statuses;
    }

    public static Integer send(Request r) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://hooks.slack.demo.example/services/CALSB/DEMO');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(5000);
        req.setBody(JSON.serialize(new Map<String, Object>{ 'channel' => r.channel, 'username' => r.postAs, 'text' => r.text }));
        return new Http().send(req).getStatusCode();
    }
}