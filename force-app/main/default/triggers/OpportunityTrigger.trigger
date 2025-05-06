trigger OpportunityTrigger on Opportunity (after insert, after update) {
    /*   if(Trigger.isInsert){
        if(Trigger.isAfter){
            OpportunityTriggerHandler.createInvoice(Trigger.New);
        }
    }
     */
    
    for(Opportunity opp: Trigger.New){
        Opportunity oldOpp = Trigger.oldMap != null ? Trigger.oldMap.get(opp.Id) : null;
        if(opp.StageName == 'Negotiations' && opp.Amount >= 10000){
            if(oldOpp == null || oldOpp.StageName != 'Negotiations'){
                OpportunityApprovalService.submitForApproval(opp);
            }
        }
        if((opp.Amount >= 50000) && (oldOpp == null || oldOpp.Amount < 50000)){
            OpportunityTriggerHandler.NotifyManager(opp);
        }
    }
}