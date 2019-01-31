public class OpportunityDomain extends fflib_SObjectDomain {
    public OpportunityDomain(List<Opportunity> SObjectList) {
        super(SObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new OpportunityDomain(sObjectList);
        }
    }
    
    public override void onAfterUpdate(map<Id, SObject> existingRecords) {
        boolean flag = false;
        boolean sendMail = false;
        Set<Id> updatedopptyIds2 = new Set<Id>();
        List<Opportunity> updatedOpportunities = (List<Opportunity>) Records;
        List<Id> opptyIds = new list<Id>();
        List<Id> updatedOpptyIds = new list<Id>();
        
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Opportunity.SObjectType,
                    OpportunityLineItem.SObjectType
                    });
        
        for(Opportunity updatedOppty : updatedOpportunities) {
            Opportunity oldOppty = (Opportunity)existingRecords.get(updatedOppty.Id);
            if((oldOppty.stagename != 'Closed Won' && oldOppty.stagename != 'Closed Lost') && 
               (updatedOppty.stagename == 'Closed Won' || updatedOppty.stagename == 'Closed Lost')) {
                   updatedOpptyIds.add(updatedOppty.Id);
                   flag = true;
               }
            if(oldOppty.Custom_Status__c != 'Reset' && updatedOppty.Custom_Status__c == 'Reset') {
                opptyIds.add(updatedOppty.Id);
            }
            if(!oldOppty.Custom_Status__c.equals(updatedOppty.Custom_Status__c) 
               || (oldOppty.Custom_Status__c == null && updatedOppty.Custom_Status__c != null)
               || (oldOppty.Custom_Status__c != null && updatedOppty.Custom_Status__c == null)) {
                   sendMail = true;
                   updatedopptyIds2.add(updatedOppty.Id);
               }
        }
        if(flag) {
            List<Opportunity> updatedOppties = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Id In :updatedOpptyIds];
            for(Opportunity opp : updatedOppties) {
                opp.CloseDate = Date.today();
            }
            uow.registerDirty(updatedOppties);
        } else if(!flag) {
            List<OpportunityLineItem> relatedOpptyLineItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN :opptyIds];
            uow.registerDeleted(relatedOpptyLineItems);
        } else if(sendMail) {
            OpportunityService opptyService = new OpportunityService();
            boolean isSuccess = opptyService.sendEmail(updatedopptyIds2);
            System.debug('sendMail boolean in domain : ' + sendMail);
        }
        uow.commitWork();
    }
}