@isTest
public class CustomProductSelectorTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            Custom_Product__c.SObjectType
                });
	@testSetup
    static void insertDataForTesting() {
        List<Custom_Product__c> pList = new List<Custom_Product__c>();
        Custom_Product__c p1 = new Custom_Product__c(Product_Name__c = 'P1', Price__c = 10.0, Quantity__c = 10, Quantity_Unit_Of_Measure__c = 'Kg.');
        pList.add(p1);
        Custom_Product__c p2 = new Custom_Product__c(Product_Name__c = 'P2', Price__c = 20.0, Quantity__c = 20, Quantity_Unit_Of_Measure__c = 'Ltr.');
        pList.add(p2);
        Custom_Product__c p3 = new Custom_Product__c(Product_Name__c = 'P3', Price__c = 30.0, Quantity__c = 30, Quantity_Unit_Of_Measure__c = 'Pc.');
        pList.add(p3);
        uow.registerNew(pList);
        uow.commitWork();
    }
    
    @isTest
    static void testGetAvailableProducts() {
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        
        Test.startTest();
        List<Custom_Product__c> availableProductsList = customProductSelectorObj.getAvailableProducts();
        System.assertEquals(3, availableProductsList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testSelectById() {
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> availableProductsList = customProductSelectorObj.getAvailableProducts();
        Set<Id> pIds = new Set<Id>();
        for(Custom_Product__c product : availableProductsList) {
            pIds.add(product.Id);
        }
        Test.startTest();
        List<Custom_Product__c> productsListBySelectById = customProductSelectorObj.selectById(pIds);
        System.assertEquals(3, productsListBySelectById.size());
        Test.stopTest();
    }
}