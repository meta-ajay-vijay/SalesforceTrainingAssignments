public class OpportunitySumRelatedAccountController {
    public List<Account> relatedOpportunityAccounts{get;set;}
    Transient Account2Selector accountSelector = new Account2Selector();
    
    public OpportunitySumRelatedAccountController() {
        //relatedOpportunityAccounts = new List<Account>();
        setRelatedOpportunityAccounts();
    }
    
    public void setRelatedOpportunityAccounts() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
        relatedOpportunityAccounts = getRelatedOpportunityAccounts();
    }
    
    public List<Account> getRelatedOpportunityAccounts() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
        relatedOpportunityAccounts = accountSelector.getAccountsWithRelatedOpportunities();
        
        for(Account acc : relatedOpportunityAccounts) {
            if(acc.OpportunitiesAmountSum__c == null) {
                acc.OpportunitiesAmountSum__c = 0;
            }
            for(Opportunity opp : acc.Opportunities) {
                acc.OpportunitiesAmountSum__c += opp.Amount;
            }
        }
        return relatedOpportunityAccounts;
    }
}