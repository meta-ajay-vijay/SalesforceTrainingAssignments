public class ClassSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Class__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Class__c.Name__c,
                Class__c.Number_Of_Students__c,
                Class__c.MaxSize__c,
                Class__c.MyCount__c
                };
                    }
    
    public List<Class__c> getClass(Id classId) {
        return (List<Class__c>) Database.query(
            newQueryFactory().
            setCondition('Id = \'' + classId + '\'').
            toSOQL()
        );
    }
    
    public List<Class__c> getAllClasses() {
        return (List<Class__c>) Database.query(
            newQueryFactory().
            selectField('Fee__c').
            selectField('Board__c').
            selectField('Class_Teacher__c').
            toSOQL()
        );
    }
    
}