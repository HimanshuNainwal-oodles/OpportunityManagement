public with sharing class OpportunityApprovalService {
    public static void submitForApproval(Opportunity opp) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(opp.Id);
        req.setComments('Auto-submit by Approval Rule');
        Approval.ProcessRequest res = Approval.process(req);
        if (result.isSuccess()) {
            System.debug('Opportunity submitted for approval successfully.');
        } else {
            System.debug('Submission failed: ' + result.getErrors());
        }
        if(!res.isSuccess()){
            throw new AuraHandledException('Approval Submission Failed: '+ res.getErrors()[0].getMessage());
        }
    }
}