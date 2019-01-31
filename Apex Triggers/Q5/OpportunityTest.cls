@isTest
public class OpportunityTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            Opportunity.SObjectType,
                OpportunityLineItem.SObjectType
                });
    
    @testSetup
    static void setup() {
        Opportunity testFutureCloseDateClosedWonOppty = new Opportunity(Name='testFutureCloseDateClosedWonOppty', StageName='Prospecting', CloseDate= Date.newInstance(2019, 01, 20), Custom_Status__c = 'New');
        uow.registerNew(testFutureCloseDateClosedWonOppty);
        Opportunity testFutureCloseDateClosedLostOppty = new Opportunity(Name='testFutureCloseDateClosedLostOppty', StageName='Prospecting', CloseDate= Date.newInstance(2019, 01, 20), Custom_Status__c = 'New');
        uow.registerNew(testFutureCloseDateClosedLostOppty);
        Opportunity testPastCloseDateClosedLostOppty = new Opportunity(Name='testPastCloseDateClosedLostOppty', StageName='Prospecting', CloseDate= Date.newInstance(2019, 01, 05), Custom_Status__c = 'New');
        uow.registerNew(testPastCloseDateClosedLostOppty);
        Opportunity testPastCloseDateClosedWonOppty = new Opportunity(Name='testPastCloseDateClosedWonOppty', StageName='Prospecting', CloseDate= Date.newInstance(2019, 01, 05), Custom_Status__c = 'New');
        uow.registerNew(testPastCloseDateClosedWonOppty);
        Opportunity testCustomStatus = new Opportunity(Name='testCustomStatus', StageName='Prospecting', CloseDate= Date.newInstance(2019, 01, 05), Custom_Status__c = 'New');
        uow.registerNew(testCustomStatus);
        for(Integer i=0; i<3; i++) {
            Id pricebookId = Test.getStandardPricebookId();
            
            //Create your product
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true
            );
            insert prod;
            
            //Create your pricebook entry
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            
            //create your opportunity line item.
            OpportunityLineItem oli = new OpportunityLineItem(
               // OpportunityId = testCustomStatus.Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id,
                TotalPrice = 5 * pbEntry.UnitPrice
            );
            uow.registerRelationship(oli, OpportunityLineItem.OpportunityId, testCustomStatus);
            uow.registerNew(oli);
        }
        uow.commitWork();
    }
    
    @isTest
    static void testFutureCloseDateClosedWonOpptyy() {
        Opportunity opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testFutureCloseDateClosedWonOppty'];
		
        Test.startTest();
        opptyToTest.StageName = 'Closed Won';
        uow.registerDirty(opptyToTest);
        uow.commitWork();
        Test.stopTest();
		
        opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testFutureCloseDateClosedWonOppty'];
        System.assertEquals(Date.today(), opptyToTest.CloseDate);
    }
    
    
    @isTest
    static void testFutureCloseDateClosedLostOpptyy() {
        Opportunity opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testFutureCloseDateClosedLostOppty'];
		
        Test.startTest();
        opptyToTest.StageName = 'Closed Lost';
        uow.registerDirty(opptyToTest);
        uow.commitWork();
        Test.stopTest();
		
        opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testFutureCloseDateClosedLostOppty'];
        System.assertEquals(Date.today(), opptyToTest.CloseDate);
    }
    
    @isTest
    static void testPastCloseDateClosedLostOpptyy() {
        Opportunity opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testPastCloseDateClosedLostOppty'];
		
        Test.startTest();
        opptyToTest.StageName = 'Closed Lost';
        uow.registerDirty(opptyToTest);
        uow.commitWork();
        Test.stopTest();
		
        opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testPastCloseDateClosedLostOppty'];
        System.assertEquals(Date.today(), opptyToTest.CloseDate);
    }
    
    @isTest
    static void testPastCloseDateClosedWonOpptyy() {
        Opportunity opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testPastCloseDateClosedWonOppty'];
		
        Test.startTest();
        opptyToTest.StageName = 'Closed Won';
        uow.registerDirty(opptyToTest);
        uow.commitWork();
        Test.stopTest();
		
        opptyToTest = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE Name='testPastCloseDateClosedWonOppty'];
        System.assertEquals(Date.today(), opptyToTest.CloseDate);
    }
    
    @isTest
    static void testCustomStatusUpdation() {
        OpportunityLineItemSelector opptyLineItemSelector = new OpportunityLineItemSelector();
        Opportunity testOppty = [SELECT Name, Custom_Status__c From Opportunity WHERE Name = 'testCustomStatus'];
        List<OpportunityLineItem> relatedOppLineItems = opptyLineItemSelector.getOpptyLineItemsByOpptyId(testOppty.Id);
		
        Test.startTest();
        testOppty.Custom_Status__c = 'Reset';
        uow.registerDirty(testOppty);
        uow.commitWork();
        Test.stopTest();
		
        testOppty = [SELECT Name, Custom_Status__c From Opportunity WHERE Name = 'testCustomStatus'];
        relatedOppLineItems = opptyLineItemSelector.getOpptyLineItemsByOpptyId(testOppty.Id);
        System.assertEquals(0, relatedOppLineItems.size());
    }
}