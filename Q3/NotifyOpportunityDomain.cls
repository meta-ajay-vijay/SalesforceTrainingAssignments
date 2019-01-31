public class NotifyOpportunityDomain extends fflib_SObjectDomain {
    public NotifyOpportunityDomain(List<Opportunity> SObjectList) {
        super(SObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new NotifyOpportunityDomain(sObjectList);
        }
    }
    
    public override void onBeforeUpdate(map<Id, SObject> existingRecords) {
        boolean sendMail = false;
        List<Opportunity> updatedOpportunities = (List<Opportunity>) Records;
        Set<Id> updatedopptyIds2 = new Set<Id>();
        OpportunityService opptyService = new OpportunityService();
        for(Opportunity updatedOppty : updatedOpportunities) {
            Opportunity oldOppty = (Opportunity)existingRecords.get(updatedOppty.Id);
            if((oldOppty.Custom_Status__c == null && updatedOppty.Custom_Status__c != null)
               || (oldOppty.Custom_Status__c != null && updatedOppty.Custom_Status__c == null)
               || !oldOppty.Custom_Status__c.equals(updatedOppty.Custom_Status__c)) {
                   updatedopptyIds2.add(updatedOppty.Id);
               }
        }
        
        opptyService.sendEmails2(updatedopptyIds2);
    }
}