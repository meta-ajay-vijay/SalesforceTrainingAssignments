public class UpdateContactsCountDomain extends fflib_SObjectDomain {
    UpdateContactsCountService serviceObj = new UpdateContactsCountService();
    
    public UpdateContactsCountDomain(List<SObject> SObjectList) {
        super(SObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new UpdateContactsCountDomain(sObjectList);
        }
    }
    
    public override void onAfterInsert() {
        serviceObj.updateOnInsert((List<Account>) Records);
    }
    
    public override void onAfterDelete() {
        serviceObj.updateOnDelete((List<Account>) Records);
    }
    
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        serviceObj.updateOnUpdate(existingRecords, (List<Account>) Records);
    }
}