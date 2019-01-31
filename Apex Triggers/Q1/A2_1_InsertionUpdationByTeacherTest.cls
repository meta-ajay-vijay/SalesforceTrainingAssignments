@isTest
public class A2_1_InsertionUpdationByTeacherTest {
    
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[] {
            Contact.SObjectType
                }
    );
    
    @testSetup
    static void setup() {
        Contact testContact = new Contact(LastName='testContact', Subjects__c='English;Maths');
        uow.registerNew(testContact);
        uow.commitWork();
    }
    
    @isTest
    static void testFailedInsertionByTeacherTrigger() {
        Test.startTest();
        try{
            Contact insertContactTest = new Contact(LastName='insertContactTest', Subjects__c='Hindi;English');
            uow.registerNew(insertContactTest);
            uow.commitWork();
            throw new ContactException('Teacher with hindi subject saved without throwing error.');
        } catch(Exception e) {
            System.Assert(e.getMessage().contains('Can not add teacher with Hindi subject.'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testFailedUpdationByTeacherTrigger() {
        Test.startTest();
        try{
            Contact updateContactTest = [SELECT Name, Subjects__c FROM Contact 
                                         WHERE LastName='testContact'].get(0);
            updateContactTest.Subjects__c = 'English;Hindi';
            uow.registerDirty(updateContactTest);
            uow.commitWork();
            throw new ContactException('Teacher with hindi subject updated without throwing error.');
        } catch(Exception e) {
            System.Assert(e.getMessage().contains('Can not update teacher with Hindi subject.'));
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void testSuccessfulInsertionByTeacherTrigger() {
        Test.startTest();
        try{
            Contact insertContactTest2 = new Contact(LastName='insertContactTest2', Subjects__c='English');
            uow.registerNew(insertContactTest2);
            uow.commitWork();
            throw new ContactException('Teacher was saved');
        } catch(Exception e) {
            System.debug('SI' + e.getMessage());
            System.Assert(e.getMessage().contains('Teacher was saved'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testSuccessfulUpdationByTeacherTrigger() {
        Test.startTest();
        try{
            Contact updateContactTest = [SELECT Name, Subjects__c FROM Contact 
                                         WHERE LastName='testContact'].get(0);
            updateContactTest.Subjects__c = 'English;Science';
            uow.registerDirty(updateContactTest);
            uow.commitWork();
            throw new ContactException('Teacher was updated');
        } catch(Exception e) {
            System.debug('SU' + e.getMessage());
            System.Assert(e.getMessage().contains('Teacher was updated'));
        }
        Test.stopTest();
        
    }
}