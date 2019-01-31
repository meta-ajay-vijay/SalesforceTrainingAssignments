@isTest
private class TestLoanEntryWithManagerFieldUpdation {
    
    @isTest
    static void myUnitTest() {
        Loan__c loanObject2 = [SELECT Id,Name__c,City__c,Manager__c FROM Loan__c WHERE Name__c = 'Test Loan'];
        User testUser = [Select Id From User Where LastName = 'last'];
        System.assertEquals(testUser.Id, loanObject2.Manager__c, 'Test User Is Saved Status In the Loan Entry.'); 
    }
    
    @testSetup
    public static void setup(){
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert testUser;
        
        CityManager__c cityManager = new CityManager__c();
        cityManager.City__c = 'Ajmer';
        cityManager.Manager__c = testUser.Id;
        insert cityManager;
        
        Loan__c loanObject = new Loan__c();
        loanObject.Name__c = 'Test Loan';
        loanObject.Amount__c = 1000;
        loanObject.City__c = 'Ajmer';
        insert loanObject;
    }
    
}