public class StudentDomain extends fflib_SObjectDomain {
    ClassSelector classSelector = new ClassSelector();
    
    public StudentDomain(List<Student__c> SObjectList) {
        super(SObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new StudentDomain(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {
        Set<Student__c> studentsToInsert = new Set<Student__c> ((List<Student__c>) Records);
        for(Student__c studentToInsert : studentsToInsert) {
            Class__c classOfStudent = classSelector.getClass(studentToInsert.Class__c).get(0);
            if(classOfStudent.Number_Of_Students__c == classOfStudent.MaxSize__c) {
                studentToInsert.addError('Class is already full.');
                break;
            }
        }
    }
    
    public override void onAfterInsert() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Class__c.SObjectType
                    });
        
        List<Class__c> classes = new List<Class__c>();
        for(Student__c student : (List<Student__c>) Records) {
            Class__c classObject = ClassSelector.getClass(student.Class__c).get(0);
           	if(classObject.MyCount__c == null) {
                classObject.MyCount__c = 1;
            } else {
                classObject.MyCount__c++;
            }
            uow.registerDirty(classObject);
            uow.commitWork();
        }
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Class__c.SObjectType
                    });
        
        List<Student__c> updatedStudents = (List<Student__c>) Records;
        for(Student__c updatedStudent : updatedStudents) {
            Student__c oldStudent = (Student__c)existingRecords.get(updatedStudent.Id);
            if(oldStudent.Class__c != updatedStudent.Class__c) {
                Class__c oldClass = ClassSelector.getClass(oldStudent.Class__c).get(0);
                oldClass.MyCount__c--;
                uow.registerDirty(oldClass);
                Class__c newClass = ClassSelector.getClass(updatedStudent.Class__c).get(0);
                if(newClass.MyCount__c == null || newClass.MyCount__c == 0) {
                    newClass.MyCount__c = 1;
                } else {
                    newClass.MyCount__c++;
                }
                uow.registerDirty(newClass);
                uow.commitWork();
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}