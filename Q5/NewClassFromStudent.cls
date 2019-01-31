public class NewClassFromStudent {
    ApexPages.StandardController controller;
    
    public NewClassFromStudent(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    ApexPages.StandardSetController setcontroller;
    
    public NewClassFromStudent(ApexPages.StandardSetController setcontroller) {
        this.setcontroller = setcontroller;
    }
    
    public PageReference reDirect() {
        PageReference pageRef = new PageReference('/apex/NewOrEditClass');
        pageRef.setRedirect(true);
        return pageRef;
    }
}