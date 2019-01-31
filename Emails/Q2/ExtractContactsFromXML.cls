public class ExtractContactsFromXML implements Messaging.InboundEmailHandler {
    List<Contact> contacts = new List<Contact>();
    Contact contact;
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        Messaging.InboundEmail.TextAttachment[] textAttachments = email.textAttachments;
        //Messaging.InboundEmail.TextAttachment textAttachments[] = email.textAttachments;  //gives error
        String contactListXML = '';
        
        if(textAttachments != null) {
            for(Messaging.InboundEmail.TextAttachment attachment : textAttachments) {
                if(attachment.filename.endsWith('.xml')) {
                    contactListXML = attachment.body;
                    
                    DOM.Document document = new DOM.Document();
                    document.load(contactListXML);
                    
                    DOM.XmlNode rootNode = document.getRootElement();
                    parseXML(rootNode);
                    contacts.add(contact);
                    insert contacts;
                }
            }
        }
        return result;
    }
    
    private void parseXML(DOM.XmlNode node){
        if(node.getNodeType() == DOM.XmlNodeType.ELEMENT) {
            if(node.getName() == 'contact') {
                if(contact != null) 
                    contacts.add(contact);
                contact = new Contact();
            }
            if(node.getName() == 'fname')
                contact.FirstName = node.getText().trim();
            if(node.getName() == 'lname')
                contact.LastName = node.getText().trim();
            if(node.getName() == 'phone')
                contact.Phone = node.getText().trim();
            if(node.getName() == 'email')
                contact.Email = node.getText().trim();
        }
        for(DOM.XmlNode child : node.getChildElements()) {
            parseXML(child);
        }
    }
}