public with sharing class StudentInfoController {
   
  Id studentId = ApexPages.currentPage().getParameters().get('id');
  
   public PageReference attachPDF() {
       PageReference pdfPage = Page.StudentInfo;
       pdfPage.getParameters().put('id', studentId);
       List<Attachment> attachmentList = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :studentId AND Name = 'student.pdf'];
       if(attachmentList.size() > 0) {
           delete attachmentList;
       }
       Attachment attach = new Attachment();
       Blob body;
       try{
           body = pdfPage.getContent();
       } catch(VisualforceException e) {
           body = Blob.valueOf('Student data');
       }
       attach.Body = body;
       attach.Name = 'student.pdf';
       attach.IsPrivate = false;
       attach.ParentId = studentId;
       upsert attach;
       return new PageReference('/' + studentId);
   }
}