@isTest
public class PurchaseOrderSelectorTest {
	static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            PurchaseOrder__c.SObjectType,
                PurchaseOrderLineItems__c.SObjectType,
                Custom_Product__c.SObjectType
                });
	@testSetup
    static void insertDataForTesting() {
        
        Custom_Product__c p1 = new Custom_Product__c(Product_Name__c = 'P1', Price__c = 10.0, Quantity__c = 10, Quantity_Unit_Of_Measure__c = 'Kg.');
        insert p1;
        PurchaseOrder__c po1 = new PurchaseOrder__c();
        insert po1;
        
        PurchaseOrderLineItems__c poli1 = new PurchaseOrderLineItems__c(Product_Name__c = 'poli1', Price__c = 10.0, Quantity__c = 1);
        poli1.CustomProductId__c = p1.Id;
        poli1.PurchaseOrderId__c = po1.Id;
        insert poli1;
        
        PurchaseOrderLineItems__c poli2 = new PurchaseOrderLineItems__c(Product_Name__c = 'poli2', Price__c = 20.0, Quantity__c = 2);
        poli2.CustomProductId__c = p1.Id;
        poli2.PurchaseOrderId__c = po1.Id;
        insert poli2;
        
        uow.commitWork();
    }
    
    @isTest
    static void testSelectById() {
        PurchaseOrderSelector purchaseOrderSelectorObj = new PurchaseOrderSelector();
        List<PurchaseOrder__c> orders = [SELECT Id FROM PurchaseOrder__c];
        
        Test.startTest();
        List<PurchaseOrder__c> testOrders = purchaseOrderSelectorObj.selectById(new Set<Id>{ orders.get(0).Id });
        Test.stopTest();
		
        System.assertEquals(orders.get(0).Id, testOrders.get(0).Id);
    }
}