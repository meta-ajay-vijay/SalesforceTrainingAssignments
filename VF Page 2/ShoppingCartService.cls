public class ShoppingCartService {
    Transient private CustomProductSelector customProductSelectorObject = new CustomProductSelector();
    Transient private PurchaseOrderLineItemSelector cartItemSelector = new PurchaseOrderLineItemSelector();
    private Custom_Product__c customProductToAdd;
    
    //Testing done
    public Map<Id, Custom_Product__c> getProductsAvailable() {
        CustomProductSelector customProductSelectorObject1 = new CustomProductSelector();
        return new Map<Id, Custom_Product__c>(customProductSelectorObject1.getAvailableProducts());
    }
    
    //Testing done
    public void addProductInCart(Id productId, Map<Id, PurchaseOrderLineItems__c> productsInCart) {
        CustomProductSelector customProductSelectorObject1 = new CustomProductSelector();
        customProductToAdd = customProductSelectorObject1.selectById(new Set<Id>{productId}).get(0);
        
        if(productsInCart.containsKey(productId)){
            PurchaseOrderLineItems__c productToAddInCart = productsInCart.get(productId);
            productToAddInCart.Quantity__c+=1;
            System.debug('update ho rhi hai? ' + productToAddInCart.Quantity__c);
            productsInCart.put(productId, productToAddInCart);
            updateProductQuantity(productId, 1, false);
        } else{
            PurchaseOrderLineItems__c productToAddInCart = new PurchaseOrderLineItems__c();
            productToAddInCart.CustomProductId__c = productId;
            productToAddInCart.Product_Name__c = customProductToAdd.Product_Name__c;
            productToAddInCart.Quantity__c = 1;
            productToAddInCart.Price__c = customProductToAdd.Price__c;
            System.debug('add first time' + productToAddInCart);
            updateProductQuantity(productId, 1, false);
            productsInCart.put(productId, productToAddInCart);
        }
    }
    //Testing done
    public OrderPojo doCheckOut(Map<Id,PurchaseOrderLineItems__c> productsInCart2) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                PurchaseOrder__c.SObjectType,
                    PurchaseOrderLineItems__c.SObjectType
                    });
        
        Decimal orderTotal = 0;
        for(Id poliId : productsInCart2.keySet()) {
            PurchaseOrderLineItems__c poliToAdd = productsInCart2.get(poliId);
            orderTotal += (poliToAdd.Quantity__c * poliToAdd.Price__c);
        }
        PurchaseOrder__c order = new PurchaseOrder__c( Order_Total__c = orderTotal);
        uow.registerNew(order);
        for(Id poliId : productsInCart2.keySet()) {
            PurchaseOrderLineItems__c poliToAdd = productsInCart2.get(poliId);
            uow.registerRelationship(poliToAdd, PurchaseOrderLineItems__c.PurchaseOrderId__c, order);
            uow.registerNew(poliToAdd);
        }
        uow.commitWork();
        Id userId =  UserInfo.getUserId();
        User orderCustomer = [SELECT Name, Email FROM User WHERE Id = :userId];
        System.debug('USER: ' + orderCustomer);
        OrderPojo orderDetails = new OrderPojo(order.Id, orderCustomer.Name, orderCustomer.Email, orderTotal);
        System.debug('ORder Details : ' + orderDetails);
        return orderDetails;
    }
    
    //Testing done
    public void updateProductQuantity(Id productId ,Integer numberOfQuantities, boolean isPositive) {
        Custom_Product__c productToUpdate = [SELECT Product_Name__c, Price__c, Quantity__c, Quantity_Unit_Of_Measure__c 
                                             FROM Custom_Product__c WHERE Id = :productId].get(0);
        // To increase quantity
        if(isPositive) {
            productToUpdate.Quantity__c = productToUpdate.Quantity__c + numberOfQuantities;
        } 
        // To decrease quantity
        else {
            productToUpdate.Quantity__c = productToUpdate.Quantity__c - numberOfQuantities;
        }
        update productToUpdate;
    }
}