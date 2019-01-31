public class A4_2_ClassDomain extends fflib_SObjectDomain {
    A4_2_StudentSelector studentSelector = new A4_2_StudentSelector();

    public A4_2_ClassDomain(List<Class__c> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new A4_2_ClassDomain(sObjectList);
        }
    }
    
    public override void onBeforedelete() {
        Set<Class__c> classSet = new Set<Class__c>((List<Class__c>) Records);
        Map<Id, List<Student__c>> classesWithStudents = studentSelector.getStudentsOfClassByClass(classSet);
        for(Class__c classToDelete : classSet) {
            List<Student__c> studentsInClassToDelete = classesWithStudents.get(classToDelete.Id);
            Integer countFemales = 0;
            for(Student__c student : studentsInClassToDelete) {
                if(student.Sex__c == 'Female') {
                    countFemales++;
                    if(countFemales > 1) {
                        classToDelete.addError('Class has more than 1 female students so cannot be delete.');
                    }
                }
            }
        }
    }
}