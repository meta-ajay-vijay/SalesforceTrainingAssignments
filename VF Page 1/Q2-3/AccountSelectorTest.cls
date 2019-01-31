@isTest
public class AccountSelectorTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
    
    @testSetup
    static void setup() {
        Account testAccount = new Account(Name='TestAccount', BillingCountry = 'Usa', BillingState = 'Ny', BillingCity = 'City');
        uow.registerNew(testAccount);
        uow.commitWork();
    }
    
	@isTest
    static void testGetAccounts() {
        AccountService accountServiceObj = new AccountService();
        AccountSelector accountSelectorObj = new AccountSelector();
        String billingCountry = 'USA';
        String billingState = 'NY';
        String billingCity = 'CITY';
        String condition = accountServiceObj.getCondition(billingCountry, billingState, billingCity);
		
        Test.startTest();
        List<Account> accounts = accountSelectorObj.getAccounts(condition);
        test.stopTest();
		
        System.assertEquals(1, accounts.size());
        System.assertEquals('TestAccount', accounts.get(0).Name);
        System.assertEquals('Usa', accounts.get(0).BillingCountry);
        System.assertEquals('Ny', accounts.get(0).BillingState);
        System.assertEquals('City', accounts.get(0).BillingCity);
    }
    
    @isTest
    static void testSelectById() {
        AccountService accountServiceObj = new AccountService();
        AccountSelector accountSelectorObj = new AccountSelector();
        String billingCountry = 'USA';
        String billingState = 'NY';
        String billingCity = 'CITY';
        String condition = accountServiceObj.getCondition(billingCountry, billingState, billingCity);
        List<Account> accounts = accountSelectorObj.getAccounts(condition);
		
        Test.startTest();
        List<Account> accounts2 = accountSelectorObj.selectById(new Set<Id> {accounts.get(0).Id});
        test.stopTest();
		
        System.assertEquals(1, accounts2.size());
        System.assertEquals('TestAccount', accounts2.get(0).Name);
        System.assertEquals('Usa', accounts2.get(0).BillingCountry);
        System.assertEquals('Ny', accounts2.get(0).BillingState);
        System.assertEquals('City', accounts2.get(0).BillingCity);
    }
}