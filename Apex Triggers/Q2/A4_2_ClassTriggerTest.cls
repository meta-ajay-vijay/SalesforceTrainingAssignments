@isTest
public class A4_2_ClassTriggerTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            Class__c.SObjectType,
                Student__c.SObjectType
                });
    
    @testSetup
    static void setup() {
        Class__c testFailedClass = new Class__c(Name__c='Test Failed Class 1', Board__c='RAJ', Fee__c=10000);
        uow.registerNew(testFailedClass);
        for(Integer countStudent = 0; countStudent < 2; countStudent++) {
            Student__c testStudent = new Student__c(First_name__c = 'TestFailStudent 1'+countStudent,Last_Name__c='TestStudent ' +1+countStudent, 
                                                    Email__c = 'TestStudent1'+countStudent+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                    Sex__c = 'Female');
            uow.registerRelationship(testStudent, Student__c.Class__c, testFailedClass);
            uow.registerNew(testStudent);
        }
        
        Class__c testSuccessfulClass = new Class__c(Name__c='Test Pass Class 2', Board__c='BIHAR', Fee__c=20000);
        uow.registerNew(testSuccessfulClass);
        
        Student__c testStudent1 = new Student__c(First_name__c = 'TestPassStudent 21',Last_Name__c='TestStudent 21', 
                                                 Email__c = 'TestStudent21'+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                 Sex__c = 'Female');
        uow.registerRelationship(testStudent1, Student__c.Class__c, testSuccessfulClass);
        uow.registerNew(testStudent1);
        
        Student__c testStudent2 = new Student__c(First_name__c = 'TestPassStudent 22',Last_Name__c='TestStudent 22', 
                                                 Email__c = 'TestStudent22'+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                 Sex__c = 'Male');
        uow.registerRelationship(testStudent2, Student__c.Class__c, testSuccessfulClass);
        uow.registerNew(testStudent2);
        
        uow.commitWork();
    }
    
    @isTest
    static void testFailedDeletion() {
        Class__c testFail = [SELECT Name__c, Board__c, Fee__c FROM Class__c WHERE Name__c = 'Test Failed Class 1'];
        try {
            uow.registerDeleted(testFail);
            uow.commitWork();
            throw new ClassException('Successfully Deleted.');
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.assert(e.getMessage().contains('Class has more than 1 female students so cannot be delete.'));
        }
    }
    
    @isTest
    static void testSuccessfulDeletion() {
        Class__c testPass = [SELECT Name__c, Board__c, Fee__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
        try {
            uow.registerDeleted(testPass);
            uow.commitWork();
            throw new ClassException('Successfully Deleted.');
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.assert(e.getMessage().contains('Successfully Deleted.'));
        }
    }
}