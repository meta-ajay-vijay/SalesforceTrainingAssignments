public class AccountSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name,
                Account.AnnualRevenue,
                Account.AccountNumber,
                Account.BillingCountry,
                Account.BillingState,
                Account.BillingCity
                };
                    }
    
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    
    public List<Account> selectById(Set<Id> idSet) {
        return (List<Account>)selectSObjectsById(idSet);
    }
    
    public List<Account> getAccounts(String condition) {
        // return [SELECT Name, AnnualRevenue, AccountNumber, BillingCountry,BillingState,BillingCity FROM Account ];
        fflib_QueryFactory queryObject = newQueryFactory();
        if(condition != null && condition != ''){
            queryObject.setCondition(condition);
        }
        return (List<Account>) Database.query(queryObject.toSOQL());
    }
}