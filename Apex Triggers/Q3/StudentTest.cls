@isTest
public class StudentTest {
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            Class__c.SObjectType,
                Student__c.SObjectType
                });
    
    @testSetup
    static void setup() {
        Class__c testFailedClass = new Class__c(Name__c='Test Failed Class 1', Board__c='RAJ', Fee__c=10000, MaxSize__c=10);
        uow.registerNew(testFailedClass);
        for(Integer countStudent = 0; countStudent < 10; countStudent++) {
            Student__c testStudent = new Student__c(First_name__c = 'TestFailStudent '+countStudent,Last_Name__c='TestFailStudent '+countStudent, 
                                                    Email__c = 'TestFailStudent'+countStudent+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                    Sex__c = 'Female');
            uow.registerRelationship(testStudent, Student__c.Class__c, testFailedClass);
            uow.registerNew(testStudent);
        }
        
        Class__c testSuccessfulClass = new Class__c(Name__c='Test Pass Class 2', Board__c='BIHAR', Fee__c=20000, MaxSize__c=10);
        uow.registerNew(testSuccessfulClass);
        
        for(Integer countStudent = 0; countStudent < 5; countStudent++) {
            Student__c testStudent = new Student__c(First_name__c = 'TestSuccessfulStudent '+countStudent,Last_Name__c='TestSuccessfulStudent '+countStudent, 
                                                    Email__c = 'TestSuccessfulStudent'+countStudent+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                    Sex__c = 'Female');
            uow.registerRelationship(testStudent, Student__c.Class__c, testSuccessfulClass);
            uow.registerNew(testStudent);
        }
        uow.commitWork();
    }
    
    @isTest
    static void testMyCountOnUpdation() {
        Class__c testMyCountClassOld = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Failed Class 1'];
        Class__c testMyCountClassNew = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
        Student__c studentFromOld = [SELECT First_Name__c, Class__c FROM Student__c WHERE First_Name__c = 'TestFailStudent 0'];
		
        Test.startTest();
        studentFromOld.Class__c = testMyCountClassNew.Id;
        uow.registerDirty(studentFromOld);
        uow.commitWork();
        Test.stopTest();
		
        testMyCountClassOld = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Failed Class 1'];
        testMyCountClassNew = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
        studentFromOld = [SELECT First_Name__c, Class__c FROM Student__c WHERE First_Name__c = 'TestFailStudent 0'];

        //test decrement
        System.assertEquals(9, testMyCountClassOld.MyCount__c);
        //test increment
        System.assertEquals(6, testMyCountClassNew.MyCount__c);
    }
    
    @isTest
    static void testMyCountOnInsertion() {
        Class__c testMyCountClass = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
		
        Test.startTest();
        for(Integer countStudent = 0; countStudent < 5; countStudent++) {
            Student__c testStudent = new Student__c(First_name__c = 'TestSuccessfulStudent '+countStudent,Last_Name__c='TestSuccessfulStudent '+countStudent, 
                                                    Email__c = 'TestSuccessfulStudent'+countStudent+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                    Sex__c = 'Female');
            uow.registerRelationship(testStudent, Student__c.Class__c, testMyCountClass);
            uow.registerNew(testStudent);
        }
        uow.commitWork();
        Test.stopTest();
        testMyCountClass = [SELECT Name__c, MyCount__c ,MaxSize__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
        System.assertEquals(10, testMyCountClass.MyCount__c);
    }
    
    @isTest
    static void testFail() {
        Class__c classFail = [SELECT Name__c, MaxSize__c, Number_Of_Students__c FROM Class__c WHERE Name__c = 'Test Failed Class 1'].get(0);
        Test.startTest();
        try{
            Student__c failStudentInsertion = new Student__c(First_name__c = 'TestFailStudent',Last_Name__c='TestFailStudent ', 
                                                             Email__c = 'TestFailStudent@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                             Sex__c = 'Female');
            uow.registerRelationship(failStudentInsertion, Student__c.Class__c, classFail);
            uow.registerNew(failStudentInsertion);
            uow.commitWork();
            throw new ClassException('Student successfully added!');
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Class is already full.'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testSuccessful() {
        Class__c classSuccessful = [SELECT Name__c, MaxSize__c, Number_Of_Students__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
        Test.startTest();
        try{
            Student__c successfulStudentInsertion = new Student__c(First_name__c = 'TestFailStudent',Last_Name__c='TestFailStudent ', 
                                                                   Email__c = 'TestFailStudent'+'@gmail.com',DOB__c = Date.newInstance(1997, 05, 02),
                                                                   Sex__c = 'Female');
            uow.registerRelationship(successfulStudentInsertion, Student__c.Class__c, classSuccessful);
            uow.registerNew(successfulStudentInsertion);
            uow.commitWork();
            throw new ClassException('Student successfully added!');
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Student successfully added!'));
        }
        Test.stopTest();
        classSuccessful = [SELECT Name__c, MaxSize__c, Number_Of_Students__c FROM Class__c WHERE Name__c = 'Test Pass Class 2'];
    }
}