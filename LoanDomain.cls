public with sharing class LoanDomain extends fflib_SObjectDomain {

    public LoanDomain(List<Loan__c> SObjectList) {
        super(SObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new LoanDomain(sObjectList);
        }
    }
    
    public override void onBeforeInsert(){
        LoanService.insertManagerInLoanEntry((List<Loan__c>)Records);
    }
}