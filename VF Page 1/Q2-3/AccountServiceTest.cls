@isTest
public class AccountServiceTest {
	@isTest
    static void testGetCondition() {
        AccountService accountServiceObj = new AccountService();
        String billingCountry = 'USA';
        String billingState = 'NY';
        String billingCity = 'CITY';
		
        String conditionExpected = 'BillingCountry Like \'%USA%\' And BillingCity Like \'%CITY%\' And BillingState Like \'%NY%\'';
		
        Test.startTest();
        String conditionActual = accountServiceObj.getCondition(billingCountry, billingState, billingCity);
        test.stopTest();
		
        System.assertEquals(conditionExpected, conditionActual);
    }
}