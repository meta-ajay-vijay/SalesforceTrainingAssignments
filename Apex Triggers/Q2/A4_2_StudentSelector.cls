public class A4_2_StudentSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType() {
        return Student__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Student__c.First_Name__c,
                Student__c.Sex__c
                };
                    }
    
    public Map<Id, List<Student__c>> getStudentsOfClassByClass(Set<Class__c> classSet) {
        Map<Id, List<Student__c>> classWithStudents = new Map<Id, List<Student__c>>();
        for(Class__c classObj : classSet) {
            List<Student__c> studentsInClass = getStudentsbyClassId(classObj.Id);
            classWithStudents.put(classObj.Id, studentsInClass);
        }
        return classWithStudents;
    }
    
    private List<Student__c> getStudentsbyClassId(Id classId) {
        return (List<Student__c>) Database.query(
            newQueryFactory()
            .setCondition('class__r.Id = \''+classId+'\'')
            .toSOQL()
        );
    }
    
}