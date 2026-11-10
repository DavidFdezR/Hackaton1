import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import DESCRIPTION_FIELD from '@salesforce/schema/CalK4B_Invoice__c.Description__c';

export default class CalK4BInvoiceHtml extends LightningElement {
    @api recordId;
    html;
    status = 'waiting';

    @wire(getRecord, { recordId: '$recordId', fields: [DESCRIPTION_FIELD] })
    wiredRecord({ data, error }) {
        if (error) {
            this.status = 'error ' + JSON.stringify(error);
        }
        if (data) {
            this.status = 'data';
            this.html = getFieldValue(data, DESCRIPTION_FIELD);
            this.applyHtml();
        }
    }

    renderedCallback() {
        this.applyHtml();
    }

    applyHtml() {
        const target = this.template.querySelector('.desc');
        if (target && this.html) {
            target.innerHTML = this.html;
        }
    }
}