public class OpportunityTriggerHandler {
    public static void NotifyManager(Opportunity opp){
        EmailTemplate_Opp_manage__mdt temp = [SELECT Body__c, DeveloperName, Subject__c, Template_Name__c
        FROM EmailTemplate_Opp_manage__mdt
        WHERE DeveloperName =:'Notify_Manager'];
        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(temp.Subject__c);
        email.setToAddresses(new String[]{'proddalakekau-8179@yopmail.com'});
       // email.setBccAddresses('himanshunainwal0@gmail.com');
        String body = buildEmailBody(opp, temp.Body__c);
        email.setHtmlBody(body);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});    
            System.debug('Send Successfully');

        } catch (Exception e) {
            System.debug('Error While Sending Mail: '+ e.getMessage());
        }
    }
    
    public static String buildEmailBody(Opportunity opp, String tempBody){
        String htmlBody = '<h4>'+tempBody+'</h4>'+
            '<p>Here is the Opportunitie Detail:</p>' +
            '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">' +
            '<thead style="background-color: #f2f2f2;">' +
            '<tr>' +
            '<th>Opportunity Name</th>'+
            '<th>Amount</th>'+
            '<th>Stage</th>'+
            '<th>Close Date</th>'+
            '</tr>' +
            '</thead>' +
            '<tbody>'+
            '<tr>'+
            '<td>'+ opp.Name +'</td>'+
            '<td>'+ opp.Amount +'</td>'+
            '<td>'+ opp.StageName +'</td>'+
            '<td>'+ opp.CloseDate +'</td>'+
            '</tr>';
        return htmlBody;
        
    }
    /*
    public static void createInvoice(List<Opportunity> oppList){
        
        List<OrderInvoice__c> oInvList = new List<OrderInvoice__c>();
        
        for(Opportunity opp: oppList){
            OrderInvoice__c oInv = new OrderInvoice__c();
            oInv.Status__c = 'Pending';
            oInv.Opportunity__c = opp.Id;
            oInvList.add(oInv);
            
        }
        
        if(!oInvList.isEmpty()){
            insert oInvList;
        }
    }
     */
}