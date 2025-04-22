public with sharing class ExchangeRateService {

    public class ResponseWrapper {
        public Map<String, Decimal> conversion_rates;
    }

    @AuraEnabled
    public static Decimal getExchangeRate(String fromCurrency, String toCurrency, Id oppId) {
        
        String endpoint = '/v6/884c432fd0420d832bf3ac56/latest/' + fromCurrency;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:CurrencyAPI' + endpoint);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            ResponseWrapper data = (ResponseWrapper) JSON.deserialize(res.getBody(), ResponseWrapper.class);
            System.debug(res.getBody());
            Decimal rate = data.conversion_rates.get(toCurrency);

            Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
            opp.Exchange_Rate__c = rate;
            update opp;

            return rate;
        } else {
            throw new AuraHandledException('Callout failed: ' + res.getStatus());
        }
    }
}