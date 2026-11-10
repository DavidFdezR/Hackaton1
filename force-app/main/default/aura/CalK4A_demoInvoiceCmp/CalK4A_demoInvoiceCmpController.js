({
    doInit: function (component) {
        var action = component.get('c.getInvoices');
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                component.set('v.invoices', response.getReturnValue());
                component.set('v.status', 'loaded ' + response.getReturnValue().length);
            } else {
                component.set('v.status', 'error ' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})