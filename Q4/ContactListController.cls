public class ContactListController {
    Opportunity opp;
    public Id contactId{get; set;}
    
    private List<Contact> getContacts() {
        opp = [Select Id, BillToContact__c, Manager__c FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];  
        System.debug(opp);
        Account accnt = [Select Id , (SELECT Name, Title, Email FROM Contacts) FROM Account WHERE Id = :opp.Manager__c];
        System.debug(accnt);
        List<Contact> contactList = accnt.Contacts;
        return contactList; 
    }
    
    public List<SelectOption> getcontactNames() {
        System.debug('getContactIds entry');
        List<Contact> contactsList = getContacts();
        System.debug('contactList: ' + contactsList);
        List<SelectOption> selectOptionList = new List<SelectOption>();
        List<Id> cIds = new List<Id>();
        for(Contact cnt : contactsList) {
            selectOptionList.add( new SelectOption(cnt.Id, cnt.Name));
        }
        System.debug('selectOptionList: ' + selectOptionList);
        return selectOptionList;
    }
    
    public void selectedContact() {
        contactId = ApexPages.currentPage().getParameters().get('ContactIdValue');  
        System.debug('cId: ' + contactId);
    }
    
    public PageReference doSave() {
        if(contactId != null) {
            System.debug('before: '+ opp.BillToContact__c);
            opp.BillToContact__c = contactId;
            update opp;
            System.debug('after: '+ opp.BillToContact__c);
        }
        
        PageReference redirectSuccess = new PageReference('/' + opp.Id);
        return redirectSuccess;
    }
    
    public PageReference clear() {
        opp.BillToContact__c = null;
        try {
            update opp;
        } catch(System.DmlException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        PageReference redirectSuccess = new PageReference('/' + opp.Id);
        return redirectSuccess;
    }
    
    public PageReference cancel() {
        PageReference redirectSuccess = new PageReference('/' + opp.Id);
        return redirectSuccess;
    }
}