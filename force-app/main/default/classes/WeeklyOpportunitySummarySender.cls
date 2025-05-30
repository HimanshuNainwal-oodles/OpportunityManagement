public class WeeklyOpportunitySummarySender implements Database.Batchable<sObject> {
        
    public Database.QueryLocator start(Database.BatchableContext bc){
        List<AggregateResult> res = [Select OwnerId from Opportunity GROUP BY OwnerId];
        Set<Id> ownerId = new Set<Id>();
        for(AggregateResult i : res){
            ownerId.add((Id)i.get('OwnerId'));
        }
        
        return Database.getQueryLocator([SELECT Id, Name, Email FROM User WHERE Id IN :ownerId]);
    }
    
    public void execute(Database.BatchableContext bc, List<User> user){
        Set<Id> ownerId = new Set<Id>();
        for(User u : user){
            ownerId.add(u.Id);
        }
        List<Opportunity> opp = [SELECT Id, IsClosed, Name, OwnerId, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE IsClosed = false AND OwnerId IN :ownerId];
        
        sendSummaryEmail(opp, user);
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Weekly Summary Emails are sent');
    }
    
    public static void sendSummaryEmail(List<Opportunity> opp, List<User> user) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String to = user.get(0).email;
        email.setToAddresses(new String[] {to});
        email.setBccAddresses(new String[]{'himanshunainwalpb@gmail.com'});
        email.setHtmlBody(buildEmailBody(opp, user.get(0).Name));
        email.setSubject('Open Opportunity Summary Batch');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        System.debug('Email Sent');
        
    }
    private static String buildEmailBody(List<Opportunity> opps, String ownerName) {
        String htmlBody = '<p>Hello '+ ownerName+',</p>' +
            '<p>Here is your summary of open Opportunities:</p>' +
            '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">' +
            '<thead style="background-color: #f2f2f2;">' +
            '<tr>' +
            '<th>Opportunity Name</th>' +
            '<th>Amount</th>' +
            '<th>Stage</th>' +
            '<th>Close Date</th>' +
            '</tr>' +
            '</thead>' +
            '<tbody>';
        
        for (Opportunity opp : opps) {
            htmlBody += '<tr>' +
                '<td>' + opp.Name + '</td>' +
                '<td>' + (opp.Amount != null ? '$' + String.valueOf(opp.Amount.setScale(2)) : 'N/A') + '</td>' +
                '<td>' + opp.StageName + '</td>' +
                '<td>' + (opp.CloseDate != null ? opp.CloseDate.format() : 'N/A') + '</td>' +
                '</tr>';
        }
        
        htmlBody += '</tbody></table>' +
            '<p>Best,<br/>Salesforce Bot</p>';
        
        return htmlBody;
        
    }
}


// public static void sendSummaryEmails() {
    //     // Step 1: Query open Opportunities
    //     List<Opportunity> openOpps = [
    //         SELECT Id, IsClosed, Name, OwnerId, StageName, CloseDate, Amount
    //         FROM Opportunity
    //         WHERE IsClosed = false
    //     ];
    
    //     Map<Id, List<Opportunity>> oppsByOwner = new Map<Id, List<Opportunity>>();
    
    //     for (Opportunity opp : openOpps) {
        //         if (!oppsByOwner.containsKey(opp.OwnerId)) {
            //             oppsByOwner.put(opp.OwnerId, new List<Opportunity>());
        //         }
        //         oppsByOwner.get(opp.OwnerId).add(opp);
    //     }
    //     Set<Id> ownerIds = oppsByOwner.keySet();
    
    //     Map<Id, User> users = new Map<Id,User>([
    //         SELECT Id, Name , Email from User WHERE Id IN :ownerIds]
    //         );
    
    //     // Step 4: Loop through owners and send emails
    //     for (Id ownerId : oppsByOwner.keySet()) {
        //         User owner = users.get(ownerId);
        //         List<Opportunity> userOpps = oppsByOwner.get(ownerId);
        
        
        //         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //         EmailTemplate_Opp_manage__mdt tempData = [SELECT Body__c, DeveloperName, Label, Subject__c, Template_Name__c
//             FROM EmailTemplate_Opp_manage__mdt WHERE DeveloperName =: 'Opportunity_Summary'];
        
        //         email.setToAddresses(new String[] { owner.Email });
        //         email.setSubject(tempData.Subject__c);
        //         String body = buildEmailBody(userOpps, owner.Name);
        //         email.setHtmlBody(body);
        
        //         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    //     }
// }
//
//     private static String buildEmailBody(List<Opportunity> opps, String ownerName) {
    //         String htmlBody = '<p>Hello '+ ownerName+',</p>' +
    //             '<p>Here is your summary of open Opportunities:</p>' +
    //             '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">' +
    //             '<thead style="background-color: #f2f2f2;">' +
    //             '<tr>' +
    //             '<th>Opportunity Name</th>' +
    //             '<th>Amount</th>' +
    //             '<th>Stage</th>' +
    //             '<th>Close Date</th>' +
    //             '</tr>' +
    //             '</thead>' +
    //             '<tbody>';
    
    //         for (Opportunity opp : opps) {
        //             htmlBody += '<tr>' +
        //                 '<td>' + opp.Name + '</td>' +
        //                 '<td>' + (opp.Amount != null ? '$' + String.valueOf(opp.Amount.setScale(2)) : 'N/A') + '</td>' +
        //                 '<td>' + opp.StageName + '</td>' +
        //                 '<td>' + (opp.CloseDate != null ? opp.CloseDate.format() : 'N/A') + '</td>' +
        //                 '</tr>';
    //         }
    
    //         htmlBody += '</tbody></table>' +
    //             '<p>Best,<br/>Salesforce Bot</p>';
    
    //         return htmlBody;
    
//     }
// }