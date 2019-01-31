public class SObjectToJson {
    public String getStudents(){
        List<Student__c> studentsToConvert = [SELECT First_Name__c, Last_Name__c FROM Student__c LIMIT 10];
        return (String)JSON.serialize(studentsToConvert);
    }
}