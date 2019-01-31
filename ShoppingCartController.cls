public class ShoppingCartController {
    Transient private CustomProductSelector customProductSelectorObject = new CustomProductSelector();
    private ShoppingCartService cartService = new ShoppingCartService();
    public Map<Id, Custom_Product__c> productsAvailable {get;set;}
    List<Id> cartProductsIds {get;set;}
    public boolean showProducts{get;set;}
    public boolean showCart{get;set;}
    public boolean showOrder{get;set;}
    public boolean showOrderPlaced{get;set;}
    public Map<Id,PurchaseOrderLineItems__c> productsInCart2{get;set;}
    public Map<Id,PurchaseOrderLineItems__c> oldProductsInCart2{get;set;}
    public PurchaseOrder__c order {get;set;}
    public OrderPojo orderDetails {get;set;}
    
    public ShoppingCartController(ApexPages.StandardSetController controller) {
        productsInCart2 = new Map<Id, PurchaseOrderLineItems__c>();
        showProducts = true;
        setProductsAvailable();
        showOrder = false;
        showOrderPlaced = false;
    }
    
    //Testing Done
    public void setProductsAvailable() {
        productsAvailable = new Map<Id, Custom_Product__c>(cartService.getProductsAvailable());
    }
    
    //Testing Done
    public void addProductInCart() {
        Id productId = ApexPages.currentPage().getParameters().get('productId');
        cartService.addProductInCart(productId, productsInCart2);
        setProductsAvailable();
        showCart = true;
        showOrderPlaced = false;
        oldProductsInCart2 = productsInCart2.deepClone();
        System.debug('before inline edit productsInCart2: ' + productsInCart2);
        System.debug('before inline edit oldProductsInCart2: ' + oldProductsInCart2);
    }
    
    //Testing Done
    public void updateCartQuantity() {
        System.debug('After inline edit productsInCart2: ' + productsInCart2);
        System.debug('after inline edit oldProductsInCart2: ' + oldProductsInCart2);
        Integer changeInQuantity;
        boolean increaseQuantity;
        for(Id poliId : oldProductsInCart2.keySet()) {
            if(productsInCart2.get(poliId).Quantity__c <= 0) {
                removeItemFromCart(poliId); 
            } else {
                changeInQuantity = (Integer) (productsInCart2.get(poliId).Quantity__c - oldProductsInCart2.get(poliId).Quantity__c);
                if(changeInQuantity != 0) {
                    if(changeInQuantity > 0) {
                        increaseQuantity = false;
                    } else {
                        changeInQuantity*=(-1);
                        increaseQuantity = true;
                    }
                    cartService.updateProductQuantity(poliId, changeInQuantity, increaseQuantity);
                }
            }
        }
        oldProductsInCart2 = productsInCart2.deepClone();
        setProductsAvailable();
        if(productsInCart2.size() == 0) {
            showCart = false;
        }
    }
    
    //Testing Done
    public void removeFromCart() {
        Id productId = ApexPages.currentPage().getParameters().get('productId');
        removeItemFromCart(productId);
        setProductsAvailable();
        if(productsInCart2.size() == 0) {
            showCart = false;
        }
    }
    
    private void removeItemFromCart(Id productId) {
        Integer changeInQuantity = (Integer) oldProductsInCart2.get(productId).Quantity__c;
        cartService.updateProductQuantity(productId, changeInQuantity, true);
        productsInCart2.remove(productId);
    }
    
    //Testing Done
    public void doCheckOut() {
        orderDetails = cartService.doCheckOut(productsInCart2);
        System.debug('Order Details In Controller: ' + orderDetails);
        showProducts = false;
        showCart = false;
        showOrder = true;
    }    
    
    //Testing Done
    public void placeOrder() {
        if(!showProducts) {
            showProducts = true;    
        }
        if(showCart) {
            showCart = false;
        }
        if(showOrder) {
            showOrder = false;
        }
        if(!showOrderPlaced) {
            showOrderPlaced = true;
        }
        setProductsAvailable();
        productsInCart2 = new Map<Id,PurchaseOrderLineItems__c>();
    } 
    
    //Testing Done
    public void resetCart() {
        Integer changeInQuantity;
        for(Id poliId : productsInCart2.keySet()) {
            changeInQuantity = (Integer) productsInCart2.get(poliId).Quantity__c;
            cartService.updateProductQuantity(poliId, changeInQuantity, true);
            productsInCart2.remove(poliId);
        }
        setProductsAvailable();
        showProducts = true;
        if(showCart) {
            showCart = false;    
        }
        showOrder = false;
    } 
    
    //Testing Done
    public void cancelOrder() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                PurchaseOrder__c.SObjectType
                    });
        PurchaseOrderSelector orderSelector = new PurchaseOrderSelector();
        resetCart();
        PurchaseOrder__c order = orderSelector.selectById(new Set<Id> { orderDetails.orderId }).get(0);
        uow.registerDeleted(order);
        uow.commitWork();
        orderDetails = new OrderPojo();
    }
}