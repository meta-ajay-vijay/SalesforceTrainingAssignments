public class DeleteStudentsController {
    public List<Student__c> studentsList {get;set;}
    private ApexPages.StandardSetController standardController;
    private Set<Id> studentIds = new Set<Id>();
    public boolean showList {get;set;}
    public String error {get;set;}
    
    public DeleteStudentsController(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
        getStudentsList();
    }
    
    public void getStudentsList() {
        studentsList = new List<Student__c>();
        for (Student__c student : (List<Student__c>)standardController.getSelected()){ 
            studentIds.add(student.Id);
        }
        studentsList = [SELECT First_Name__c, Last_Name__c, Email__c, Age__c, Married__c FROM Student__c WHERE ID IN: studentIds];
        if(studentsList.size() > 0) {
            showList = true;
        } else {
            showList = false;
            error = 'No records selected!';
        }
    }
    
    public PageReference  deleteSelectedRecords() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Student__c.SObjectType
                    });
        if(studentsList != null) {
            uow.registerDeleted(studentsList);
            uow.commitWork();
        }
        return returnToListView();
    }
    
    public PageReference returnToListView() {
        studentsList = null;
        Schema.DescribeSObjectResult result = Student__c.SObjectType.getDescribe();
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
        pageRef.setRedirect(true);
        return pageRef;
    }
}