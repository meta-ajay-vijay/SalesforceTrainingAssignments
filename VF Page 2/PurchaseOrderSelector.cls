public class PurchaseOrderSelector extends fflib_SObjectSelector {
public Schema.SObjectType getSObjectType() {
        return PurchaseOrder__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            PurchaseOrder__c.Id
                };
                    }
    
    public List<PurchaseOrder__c> selectById(Set<Id> idset) {
        return (List<PurchaseOrder__c>) [SELECT Id FROM PurchaseOrder__c WHERE Id IN :idset];
    }
}