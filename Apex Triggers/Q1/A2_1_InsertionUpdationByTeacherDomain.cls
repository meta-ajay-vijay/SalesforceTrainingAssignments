public class A2_1_InsertionUpdationByTeacherDomain extends fflib_SObjectDomain {
    
    fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[]{
            Contact.SObjectType
                });
    
    public A2_1_InsertionUpdationByTeacherDomain(List<Contact> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new A2_1_InsertionUpdationByTeacherDomain(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {
        for(Contact contactToBeInserted : (List<Contact>)Records) {
            if(contactToBeInserted.Subjects__c.contains('Hindi')) {
                contactToBeInserted.Subjects__c.addError('Can not add teacher with Hindi subject.');
            }
        }
    }
    
    public override void onBeforeUpdate(Map<Id, SObject> existingContactRecords) {
        for(Contact contactToBeInserted : (List<Contact>)Records) {
            if(contactToBeInserted.Subjects__c.contains('Hindi')) {
                contactToBeInserted.Subjects__c.addError('Can not update teacher with Hindi subject.');
            }
        }
    }
    
}