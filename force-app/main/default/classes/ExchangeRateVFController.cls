public with sharing class ExchangeRateVFController {
    public Id recordId { get; set; }
    public String message { get; set; }

    public ExchangeRateVFController() {
        recordId = ApexPages.currentPage().getParameters().get('id'); // lowercase 'id'
    }

    public void runExchange() {
        try {
            Decimal rate = ExchangeRateService.getExchangeRate('INR', 'USD', recordId);
            message = 'Exchange rate (INR to USD) updated: ' + rate;
        } catch (Exception e) {
            message = 'Failed to update exchange rate: ' + e.getMessage();
        }
    }

    public PageReference goBack() {
        return new PageReference('/' + recordId);
    }
}