@isTest
public class ShoppingCartServiceTest {
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
    static void testGetProductsAvailable() {
        ShoppingCartService shoppingCartServiceObj = new ShoppingCartService();
        
        Test.startTest();
        Map<Id, Custom_Product__c> productsAvailable = shoppingCartServiceObj.getProductsAvailable();
        Custom_Product__c cp = productsAvailable.values().get(0);
        Test.stopTest();
		
        System.assertEquals(3, productsAvailable.size());
        System.assertEquals('P1', cp.Product_Name__c);
    }
    
    @isTest
    static void testAddProductInCart() {
        ShoppingCartService shoppingCartServiceObj = new ShoppingCartService();
        
        Map<Id, PurchaseOrderLineItems__c> cartList = new Map<Id, PurchaseOrderLineItems__c>();
        
        Custom_Product__c cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        
        Test.startTest();
        System.assertEquals(10, cp.Quantity__c);
        shoppingCartServiceObj.addProductInCart(cp.Id, cartList);
        System.assertEquals(1, cartList.size());
        cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        System.assertEquals(9, cp.Quantity__c);
        shoppingCartServiceObj.addProductInCart(cp.Id, cartList);
        System.assertEquals(1, cartList.size());
        cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        Test.stopTest();
		
        System.assertEquals(8, cp.Quantity__c);
    }
    
    @isTest
    static void testDoCheckout() {
        ShoppingCartService shoppingCartServiceObj = new ShoppingCartService();
        Map<Id, PurchaseOrderLineItems__c> cartList = new Map<Id, PurchaseOrderLineItems__c>();
        Custom_Product__c cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        shoppingCartServiceObj.addProductInCart(cp.Id, cartList);
        shoppingCartServiceObj.addProductInCart(cp.Id, cartList);
        
        Test.startTest();
        OrderPojo order = shoppingCartServiceObj.doCheckOut(cartList);
        Test.stopTest();
		
        System.assertEquals(20.0, order.orderTotal);
    }

	@isTest
    static void testUpdateProductQuantity() {
        ShoppingCartService shoppingCartServiceObj = new ShoppingCartService();
        Custom_Product__c cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        
        Test.startTest();
        System.assertEquals(10, cp.Quantity__c);
        
        shoppingCartServiceObj.updateProductQuantity(cp.Id, 10, true);
        cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        System.assertEquals(20, cp.Quantity__c);
        
        shoppingCartServiceObj.updateProductQuantity(cp.Id, 5, false);
        cp = shoppingCartServiceObj.getProductsAvailable().values().get(0);
        Test.stopTest();
		
        System.assertEquals(15, cp.Quantity__c);
    }
}