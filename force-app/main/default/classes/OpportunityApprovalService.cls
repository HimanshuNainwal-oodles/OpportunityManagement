global with sharing class OpportunityApprovalService {
    public static void submitForApproval(Opportunity opp) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(opp.Id);
        req.setComments('Auto-submit by Approval Rule');
        Approval.ProcessResult res = Approval.process(req);
        if (res.isSuccess()) {
            System.debug('Opportunity submitted for approval successfully.');
        } else {
            System.debug('Submission failed: ' + res.getErrors());
        }
        if(!res.isSuccess()){
            throw new AuraHandledException('Approval Submission Failed: '+ res.getErrors()[0].getMessage());
        }
    }
}   