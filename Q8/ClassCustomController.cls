public class ClassCustomController {
    private Class__c classElement;
    public Id classId{get;set;}
    public boolean showEditBlock {get;set;}

    
    public List<Class__c> getClasses() {
        List<Class__c> results = [SELECT Name__c, Fee__c, Board__c, MaxSize__c, MyCount__c, Class_Teacher__c
                                  FROM Class__c];
        return results;
    }
    
    public Class__c getClassElement() {
        return classElement;
    }
    
    public void setClassElement() {
        showEditBlock = true;
        classElement = [Select Name__c , Fee__c, Board__c, MaxSize__c, MyCount__c 
                        FROM Class__c 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('classIdForEdit')];
    }
    
    public void save() {
        try {
            update(classElement);
            showEditBlock = false;
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
    }
    public void deleteClass() {
        classElement = [Select Name__c , Fee__c, Board__c, MaxSize__c, MyCount__c 
                        FROM Class__c 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('classIdForDelete')];
        
        if (classElement != null) {
            Delete classElement;
        }
    }    
}