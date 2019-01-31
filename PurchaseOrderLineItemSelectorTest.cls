@isTest
public class PurchaseOrderLineItemSelectorTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            PurchaseOrder__c.SObjectType,
                PurchaseOrderLineItems__c.SObjectType,
                Custom_Product__c.SObjectType
                });
	@testSetup
    static void insertDataForTesting() {
        
        Custom_Product__c p1 = new Custom_Product__c(Product_Name__c = 'P1', Price__c = 10.0, Quantity__c = 10, Quantity_Unit_Of_Measure__c = 'Kg.');
        //uow.registerNew(p1);
        insert p1;
        PurchaseOrder__c po1 = new PurchaseOrder__c();
        //uow.registerNew(po1);
        insert po1;
        
        PurchaseOrderLineItems__c poli1 = new PurchaseOrderLineItems__c(Product_Name__c = 'poli1', Price__c = 10.0, Quantity__c = 1);
        poli1.CustomProductId__c = p1.Id;
        poli1.PurchaseOrderId__c = po1.Id;
        insert poli1;
        //uow.registerRelationship(poli1, PurchaseOrderLineItems__c.CustomProductId__c, p1);
        //uow.registerNew(poli1, PurchaseOrderLineItems__c.PurchaseOrderId__c, po1);
        //uow.registerNew(poli1);
        
        PurchaseOrderLineItems__c poli2 = new PurchaseOrderLineItems__c(Product_Name__c = 'poli2', Price__c = 20.0, Quantity__c = 2);
        poli2.CustomProductId__c = p1.Id;
        poli2.PurchaseOrderId__c = po1.Id;
        insert poli2;
        //uow.registerRelationship(poli2, PurchaseOrderLineItems__c.CustomProductId__c, p1);
        //uow.registerNew(poli2, PurchaseOrderLineItems__c.PurchaseOrderId__c, po1);
        //uow.registerNew(poli2);
        
        uow.commitWork();
    }
    
    @isTest
    static void testGetPurchaseOrderLineItemsByProductId() {
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> availableProductsList = customProductSelectorObj.getAvailableProducts();
        PurchaseOrderLineItemSelector purchaseOrderLineItemSelectorObj = new PurchaseOrderLineItemSelector();
        Id productId = availableProductsList.get(0).Id;
        Test.startTest();
        List<PurchaseOrderLineItems__c> poliList = purchaseOrderLineItemSelectorObj.getPurchaseOrderLineItemsByProductId(productId);
        System.assertEquals(2, poliList.size());
        Test.stopTest();
    }
}