import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import listInvoices from '@salesforce/apex/CalK4B_InvoiceController.listInvoices';
import NAME_FIELD from '@salesforce/schema/CalK4B_Invoice__c.Name';

export default class CalK4BInvoiceTable extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] }) record;
    @wire(listInvoices) invoices;
}