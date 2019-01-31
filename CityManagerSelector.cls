public class CityManagerSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            CityManager__c.Id,
                CityManager__c.City__c,
                CityManager__c.Manager__c
                };
                    }
    
    public Schema.SObjectType getSObjectType() {
        return CityManager__c.sObjectType;
    }
    
    public List<CityManager__c> selectById(Set<ID> idSet) {
        return (List<CityManager__c>) selectSObjectsById(idSet);
    }
    
    public List<CityManager__c> selectCityManagerByName(Set<String> cityNames){
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('City__c IN :cityNames');
        return (List<CityManager__c>) Database.query(query.toSOQL());
    }
}