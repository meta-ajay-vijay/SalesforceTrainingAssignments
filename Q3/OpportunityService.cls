public class OpportunityService {
    OpportunitySelector opptySelector = new OpportunitySelector();
    
    public boolean sendEmails(Set<Id> opptyIds) {
        boolean isSuccess = true;
        Map<Id,Id> ownerOpptyMap = getOwnerIds(opptyIds);
        EmailTemplate eTemp = [select id,name from EmailTemplate where name ='OpportunityOwnerNotify' and isActive = true Limit 1];
        try{
            Messaging.MassEmailMessage emails = new Messaging.MassEmailMessage(); 
            emails.setTargetObjectIds(new List<Id> (ownerOpptyMap.keySet()));
            emails.setReplyTo('akvrocks1997@gmail.com'); 
            emails.setSenderDisplayName('System Admin');
            emails.setSaveAsActivity(false);
            
            emails.setTemplateId(eTemp.Id); 
            emails.setWhatIds(new List<Id> (opptyIds));
            List<Messaging.SendEmailResult> results = Messaging.SendEmail(new Messaging.MassEmailMessage[] { emails });
            System.debug('Mail sent result : ' + results);
        } catch(Exception e) {
            isSuccess = false;
            System.debug('Mail sent Exception: ' + e.getMessage());
        }
        
        return isSuccess;
    }
    
    public boolean sendEmails2(Set<Id> opptyIds) {
        System.debug('Entry in SendEmails2');
        boolean isSuccess = true;
        try{
            List<Opportunity> oppties = [SELECT Name, OwnerId FROM Opportunity WHERE Id IN :opptyIds];
            Messaging.Email[] messages = new Messaging.Email[0];

            for(Opportunity oppty : oppties) {
                EmailTemplate eTemp = [select id,name from EmailTemplate where name ='OpportunityOwnerNotify' and isActive = true Limit 1];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(oppty.OwnerId);
                message.setTemplateId(eTemp.Id);
                message.setWhatId(oppty.Id);
                message.setReplyTo('akvrocks1997@gmail.com'); 
                message.setSaveAsActivity(false);
                messages.add(message);
            }
            if(messages.size() > 0) {
                Messaging.SendEmailResult[] mailResults = Messaging.sendEmail(messages, true);
            }
        } catch(Exception e) {
            System.debug('Exception : ' + e.getMessage());
        }
        return isSuccess;
    }
    
    /*public boolean sendEmails2(Set<Id> opptyIds) {
        System.debug('Entry in SendEmails2');
        boolean isSuccess = true;
        try{
            Messaging.Email[] messages = new Messaging.Email[0];
            Map<Id,Id> ownerOpptyMap = getOwnerIds(opptyIds);
            Set<Id> ownerIds = ownerOpptyMap.keySet();
            
            for(Id ownerId : ownerIds) {
                EmailTemplate eTemp = [select id,name from EmailTemplate where name ='OpprtunityChangedMailToOwner' and isActive = true Limit 1];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(ownerId);
                message.setTemplateId(eTemp.Id);
                message.setReplyTo('akvrocks1997@gmail.com'); 
                message.setSaveAsActivity(false);
                messages.add(message);
            }
            if(messages.size() > 0) {
                Messaging.SendEmailResult[] mailResults = Messaging.sendEmail(messages, true);
            }
        } catch(Exception e) {
            System.debug('Exception : ' + e.getMessage());
        }
        return isSuccess;
    }*/
    
    private List<String> getEmailAddressesOfOwnersOfOppties(Set<Id> opptyIds) {
        Map<Id,Id> ownerOpptyMap = getOwnerIds(opptyIds);
        Set<Id> ownerIds = ownerOpptyMap.keySet();
        List<String> updatedOpptyOwnerEmails = new list<String>();
        List<User> owners = [SELECT Email FROM User WHERE Id IN :ownerIds];
        for(User owner : owners) {
            updatedOpptyOwnerEmails.add(owner.Email);
        }
        return updatedOpptyOwnerEmails;
    }
    
    private Map<Id,Id> getOwnerIds(Set<Id> opptyIds) {
        Map<Id,Id> ownerOpptyMap = new Map<Id,Id>();
        List<Opportunity> updatedOpportunities = opptySelector.selectByIds(opptyIds);
        //Set<Id> ownerIds = new Set<Id>();
        for(Opportunity oppty : updatedOpportunities) {
            ownerOpptyMap.put(oppty.OwnerId, oppty.Id);
            //ownerIds.add(oppty.OwnerId);
        }
        return ownerOpptyMap;
    }
}