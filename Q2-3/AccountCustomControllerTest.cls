@isTest
public class AccountCustomControllerTest {
	static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType
                    });
    
    @testSetup
    static void setup() {
        lIST<Account> accounts = new List<Account>();
        for(Integer i = 1; i <= 8; i++) {
            Account testAccount1 = new Account(Name='TestAccount1'+i, BillingCountry = 'Usa', BillingState = 'Ny', BillingCity = 'City');
            accounts.add(testAccount1);
            Account testAccount2 = new Account(Name='TestAccount2'+i, BillingCountry = 'Us', BillingState = 'Ny', BillingCity = 'City');
            accounts.add(testAccount2);
        }
        //Account testAccount1 = new Account(Name='TestAccount1', BillingCountry = 'Usa', BillingState = 'Ny', BillingCity = 'City');
        //uow.registerNew(testAccount1);
        //Account testAccount2 = new Account(Name='TestAccount2', BillingCountry = 'Us', BillingState = 'Ny', BillingCity = 'City');
        uow.registerNew(accounts);
        uow.commitWork();
    }
    
    @isTest
    static void testSetAccountList() {
        AccountCustomController accountCustomControllerObj = new AccountCustomController();
        Test.startTest();
        accountCustomControllerObj.billingCountry = 'USA';
        accountCustomControllerObj.billingState = 'NY';
        accountCustomControllerObj.billingCity = 'City';
        accountCustomControllerObj.setAccountList();
        System.assertEquals(8, accountCustomControllerObj.accountList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testGetAccountList() {
        AccountCustomController accountCustomControllerObj = new AccountCustomController();
        Test.startTest();
        accountCustomControllerObj.billingCountry = 'US';
        accountCustomControllerObj.billingState = 'NY';
        accountCustomControllerObj.billingCity = 'City';
        List<Account> accountList = accountCustomControllerObj.getAccountList();
        System.assertEquals(10, accountList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testSearchAccounts() {
        AccountCustomController accountCustomControllerObj = new AccountCustomController();
        
        Test.startTest();
        accountCustomControllerObj.billingCountry = 'US';
        accountCustomControllerObj.billingState = 'NY';
        accountCustomControllerObj.billingCity = 'City';
        accountCustomControllerObj.searchAccounts();
        System.assertEquals(10, accountCustomControllerObj.accountList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testNextPage() {
        ApexPages.StandardSetController controller;
        AccountCustomController accountCustomControllerObj = new AccountCustomController(controller);
        Test.startTest();
        accountCustomControllerObj.nextPage();
        System.assertEquals(6, accountCustomControllerObj.setController.getRecords().size());
        Test.stopTest();
    }
    
    @isTest
    static void testPreviousPage() {
        ApexPages.StandardSetController controller;
        AccountCustomController accountCustomControllerObj = new AccountCustomController(controller);
        Test.startTest();
        accountCustomControllerObj.nextPage();
        System.assertEquals(6, accountCustomControllerObj.setController.getRecords().size());
        accountCustomControllerObj.previousPage();
        System.assertEquals(10, accountCustomControllerObj.setController.getRecords().size());
        Test.stopTest();
    }
    
    @isTest
    static void testLastPage() {
        ApexPages.StandardSetController controller;
        AccountCustomController accountCustomControllerObj = new AccountCustomController(controller);
        Test.startTest();
        accountCustomControllerObj.lastPage();
        System.assertEquals(6, accountCustomControllerObj.setController.getRecords().size());
        Test.stopTest();
    }
    
    @isTest
    static void testFirstPage() {
        ApexPages.StandardSetController controller;
        AccountCustomController accountCustomControllerObj = new AccountCustomController(controller);
        Test.startTest();
        accountCustomControllerObj.lastPage();
        System.assertEquals(6, accountCustomControllerObj.setController.getRecords().size());
        accountCustomControllerObj.firstPage();
        System.assertEquals(10, accountCustomControllerObj.setController.getRecords().size());
        Test.stopTest();
    }
}