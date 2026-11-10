// S-101 before-state: global one-argument getPrice that the agent's change would replace.
global with sharing class CalHK_PricingApi {
    global static Decimal getPrice(Id productId) { return 100; }
}