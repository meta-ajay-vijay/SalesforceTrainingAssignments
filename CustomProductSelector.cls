public class CustomProductSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Custom_Product__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Custom_Product__c.Product_Name__c,
                Custom_Product__c.Price__c,
                Custom_Product__c.Quantity__c,
                Custom_Product__c.Quantity_Unit_Of_Measure__c
                };
                    }
    
    public List<Custom_Product__c> selectById(Set<ID> idSet) {
        return (List<Custom_Product__c>) selectSObjectsById(idSet);
    }
    
    public List<Custom_Product__c> getAvailableProducts() {
        fflib_QueryFactory factory = newQueryFactory();
        factory.setCondition('Quantity__c > 0');
        return (List<Custom_Product__c>) Database.query(factory.toSOQL());
    }
}