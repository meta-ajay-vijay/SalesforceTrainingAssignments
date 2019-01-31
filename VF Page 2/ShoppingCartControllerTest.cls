@isTest
public class ShoppingCartControllerTest {
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
    static void testSetProductsAvailable() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        
        Test.startTest();
        shoppingCartControllerObj.setProductsAvailable();
        Test.stopTest();        
        System.assertEquals(3, shoppingCartControllerObj.productsAvailable.size());
    }
    
    @isTest
    static void testAddProductInCart() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        
        Test.startTest();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            
            shoppingCartControllerObj.addProductInCart();
        }
        Test.stopTest();
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.size());
    }
    
    @isTest
    static void testUpdateCartQuantity() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        Test.startTest();
        System.assertEquals(1, shoppingCartControllerObj.productsInCart2.values().get(0).Quantity__c);
        System.assertEquals(1, shoppingCartControllerObj.oldProductsInCart2.values().get(0).Quantity__c);
        
        shoppingCartControllerObj.productsInCart2.values().get(0).Quantity__c = 3;
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.values().get(0).Quantity__c);
        System.assertEquals(1, shoppingCartControllerObj.oldProductsInCart2.values().get(0).Quantity__c);
        
        shoppingCartControllerObj.updateCartQuantity();
        Test.stopTest();
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.values().get(0).Quantity__c);
        System.assertEquals(3, shoppingCartControllerObj.oldProductsInCart2.values().get(0).Quantity__c);
    }
    
    @isTest
    static void testRemoveFromCart() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        Custom_Product__c productToRemove = products.get(0);
        
        Test.startTest();
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.size());
        
        PageReference pageReference = Page.ShoppingCart;
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put('productId', productToRemove.Id);
        shoppingCartControllerObj.removeFromCart();
        Test.stopTest();
        System.assertEquals(2, shoppingCartControllerObj.productsInCart2.size());
    }
    
    /*@isTest
    static void testRemoveItemFromCart() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        Test.startTest();
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.size());
        Id pId = shoppingCartControllerObj.productsInCart2.values().get(0).Id;
        shoppingCartControllerObj.removeItemFromCart(pId);
        Test.stopTest();
        System.assertEquals(2, shoppingCartControllerObj.productsInCart2.size());
    }*/
    @isTest
    static void testDoCheckout() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        Test.startTest();
        shoppingCartControllerObj.doCheckOut();
        Test.stopTest();
        System.assertEquals(60.0, shoppingCartControllerObj.orderDetails.orderTotal);
    }
    
    @isTest
    static void testPlaceOrder() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        
        Test.startTest();
        System.assertEquals(10, products.get(0).Quantity__c);
        System.assertEquals(20, products.get(1).Quantity__c);
        System.assertEquals(30, products.get(2).Quantity__c);
        
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.size());
        
        shoppingCartControllerObj.placeOrder();
        
        System.assertEquals(0, shoppingCartControllerObj.productsInCart2.size());
        
        products = customProductSelectorObj.getAvailableProducts();
        Test.stopTest();
		
        System.assertEquals(9, products.get(0).Quantity__c);
        System.assertEquals(19, products.get(1).Quantity__c);
        System.assertEquals(29, products.get(2).Quantity__c);
    }
	
	@isTest
    static void testResetCart() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        
        Test.startTest();
        System.assertEquals(10, products.get(0).Quantity__c);
        System.assertEquals(20, products.get(1).Quantity__c);
        System.assertEquals(30, products.get(2).Quantity__c);
        
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        System.assertEquals(3, shoppingCartControllerObj.productsInCart2.size());
        
        products = customProductSelectorObj.getAvailableProducts();
        
        System.assertEquals(9, products.get(0).Quantity__c);
        System.assertEquals(19, products.get(1).Quantity__c);
        System.assertEquals(29, products.get(2).Quantity__c);
		
        shoppingCartControllerObj.resetCart();
        
        System.assertEquals(0, shoppingCartControllerObj.productsInCart2.size());
        
        products = customProductSelectorObj.getAvailableProducts();
        Test.stopTest();
        
        System.assertEquals(10, products.get(0).Quantity__c);
        System.assertEquals(20, products.get(1).Quantity__c);
        System.assertEquals(30, products.get(2).Quantity__c);
    }
	
	@isTest
    static void testCancelOrder() {
        ApexPages.StandardSetController controller;
        ShoppingCartController shoppingCartControllerObj = new ShoppingCartController(controller);
        CustomProductSelector customProductSelectorObj = new CustomProductSelector();
        
        List<Custom_Product__c> products = customProductSelectorObj.getAvailableProducts();
        for(Custom_Product__c product : products) {
            PageReference pageReference = Page.ShoppingCart;
            Test.setCurrentPage(pageReference);
            ApexPages.currentPage().getParameters().put('productId', product.Id);
            shoppingCartControllerObj.addProductInCart();
        }
        
        shoppingCartControllerObj.doCheckOut();
        
        products = customProductSelectorObj.getAvailableProducts();
        
        Test.startTest();
        System.assertEquals(9, products.get(0).Quantity__c);
        System.assertEquals(19, products.get(1).Quantity__c);
        System.assertEquals(29, products.get(2).Quantity__c);
        
        System.assertEquals(60.0, shoppingCartControllerObj.orderDetails.orderTotal);
        
        shoppingCartControllerObj.cancelOrder();
        
        products = customProductSelectorObj.getAvailableProducts();
        Test.stopTest();
		
        System.assertEquals(10, products.get(0).Quantity__c);
        System.assertEquals(20, products.get(1).Quantity__c);
        System.assertEquals(30, products.get(2).Quantity__c);
    }
}