public class UpdateContactsCountService {
    
    private List<Id> getParentAccountsIds(List<Account> records) {
        List<Id> parentAccountIds = new List<Id>();
        for(Account acc : records) {
            if(acc.ParentId != null) {
                parentAccountIds.add(acc.ParentId);
            }
        }
        return parentAccountIds;
    }
    
    private  List<Account> getParentAccountsByIds(List<Id> parentAccountIds) {
        List<Account> parentAccounts = [SELECT Name, Child_Count__c FROM Account 
                                        WHERE Id IN :parentAccountIds];
        return parentAccounts;
    }
    
    public void updateOnInsert(List<Account> records) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
        List<Id> parentAccountIds = getParentAccountsIds(records);
        List<Account> parentAccounts = getParentAccountsByIds(parentAccountIds);
        for(Account acc : parentAccounts) {
            if(acc.Child_Count__c == null) {
                acc.Child_Count__c = 1;
            } else {
                acc.Child_Count__c++;
            }
        }
        uow.registerDirty(parentAccounts);
        uow.commitWork();
    }
    
    public void updateOnDelete(List<Account> records) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
        
        List<Id> parentAccountIds = getParentAccountsIds(records);
        List<Account> parentAccounts = getParentAccountsByIds(parentAccountIds);
        for(Account acc : parentAccounts) {
            if(acc.Child_Count__c != null && acc.Child_Count__c > 0) {
                acc.Child_Count__c -= 1;
            }
        }
        uow.registerDirty(parentAccounts);
        uow.commitWork();
    }
    
    public void updateOnUpdate(Map<Id, SObject> existingRecords, List<Account> records) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
        List<Id> AccountIdsToIncreaseCount = new List<Id>();
        List<Id> AccountIdsToDecreaseCount = new List<Id>();
        
        for(Account newAcc : records) {
            Account oldAcc = (Account) existingRecords.get(newAcc.Id);
            if(oldAcc.ParentId == null && newAcc.ParentId != null) {
                AccountIdsToIncreaseCount.add(newAcc.ParentId);
            } else if(oldAcc.ParentId != null && newAcc.ParentId == null) {
                AccountIdsToDecreaseCount.add(oldAcc.ParentId);
            } else if(oldAcc.ParentId != newAcc.ParentId) {
                AccountIdsToIncreaseCount.add(newAcc.ParentId);
                AccountIdsToDecreaseCount.add(oldAcc.ParentId);
            }
        }
       
        List<Account> AccountsToIncreaseCount = getParentAccountsByIds(AccountIdsToIncreaseCount);
        for(Account acc : AccountsToIncreaseCount) {
            if(acc.Child_Count__c == null) {
                acc.Child_Count__c = 1;
            } else {
                acc.Child_Count__c++;
            }
        }
        uow.registerDirty(AccountsToIncreaseCount); 
        
        List<Account> AccountsToDecreaseCount = getParentAccountsByIds(AccountIdsToDecreaseCount);
        for(Account acc : AccountsToDecreaseCount) {
            if(acc.Child_Count__c != null && acc.Child_Count__c > 0) {
                acc.Child_Count__c -= 1;
            }
        }
        uow.registerDirty(AccountsToDecreaseCount);
        uow.commitWork();
    }
    
}