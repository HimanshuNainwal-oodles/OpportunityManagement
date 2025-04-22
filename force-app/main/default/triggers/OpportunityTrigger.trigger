trigger OpportunityTrigger on Opportunity (after insert, after update) {
 /*   if(Trigger.isInsert){        
        if(Trigger.isAfter){
            OpportunityTriggerHandler.createInvoice(Trigger.New);
        }
    }
    */
    
    for(Opportunity opp: Trigger.New){
        if(opp.StageName == 'Negotiations' && opp.Amount >= 10000){
            Opportunity oldOpp = Trigger.oldMap != null ? Trigger.oldMap.get(opp.Id) : null;
            if(oldOpp == null || oldOpp.StageName != 'Negotiations'){
                OpportunityApprovalService.submitForApproval(opp);
            }
        }
        else{
            OpportunityTriggerHandler.NotifyManager(opp);
        }
    }
}