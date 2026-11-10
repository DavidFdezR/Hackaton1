import { LightningElement, wire } from 'lwc';
import getMyOpenInvoices from '@salesforce/apex/CalK1_DemoInvoiceController.getMyOpenInvoices';

export default class CalK1DemoInvoiceTable extends LightningElement {
    invoices = [];

    @wire(getMyOpenInvoices)
    wired({ data }) {
        if (data) {
            this.invoices = data;
        }
    }
}