public class PurchaseOrderLineItemSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return PurchaseOrderLineItems__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            PurchaseOrderLineItems__c.Quantity__c,
                PurchaseOrderLineItems__c.Total_Price__c
                };
                    }
    
    public List<PurchaseOrderLineItems__c> getPurchaseOrderLineItemsByProductId(Id productId) {
        fflib_QueryFactory factory = newQueryFactory();
        factory.selectFields(new List<String> { 'CustomProductId__r.Product_Name__c', 'CustomProductId__r.Price__c' });
        factory.setCondition('CustomProductId__c = \'' + productId +'\' ');
        return (List<PurchaseOrderLineItems__c>) Database.query(factory.toSOQL());
        //return [SELECT CustomProductId__r.Product_Name__c, CustomProductId__r.Price__c, Quantity__c, Total_Price__c 
        //       FROM PurchaseOrderLineItems__c WHERE CustomProductId__c = :productId];
    }
}