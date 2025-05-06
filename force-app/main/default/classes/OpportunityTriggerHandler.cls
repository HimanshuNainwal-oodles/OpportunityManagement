public class OpportunityTriggerHandler {
    public static void NotifyManager(Opportunity opp){
        EmailTemplate_Opp_manage__mdt temp = [SELECT Body__c, DeveloperName, Subject__c, Template_Name__c
        FROM EmailTemplate_Opp_manage__mdt
        WHERE DeveloperName =:'Notify_Manager'];
        
        Set<Id> managerIds = [SELECT Id FROM UserRole WHERE Name=:'Sales Manager'];
        
        List<User> managers = [ SELECT Name, Email FROM User WHERE UserRoleId IN :managerIds];
        
        List<String> managerMail = new List<String>();
        for(User us : managers){
            managerMail.add(us.Email);
        }
        if(managerMail != null){
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(temp.Subject__c);
            email.setToAddresses(managerMail);
            email.setBccAddresses(new String[]{'himanshunainwal0@gmail.com'});
            String body = buildEmailBody(opp, temp.Body__c);
            email.setHtmlBody(body);
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                System.debug('Send Successfully');
                
            } catch (Exception e) {
                System.debug('Error While Sending Mail: '+ e.getMessage());
            }
        }
    }
    
    public static String buildEmailBody(Opportunity opp, String tempBody){
        String htmlBody = '<h4>'+tempBody+'</h4>'+
            '<p>Here is the High value Opportunity Detail:</p>' +
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
}