import static org.junit.Assert.*;

import org.junit.Test;

import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.enterprise.sobject.Contact;
import com.sforce.soap.enterprise.sobject.SObject;

public class ContactQueryTest {

	@Test
	public void testMainFunctionality() throws Exception {
		ContactQuery contactQueryObject = new ContactQuery();
		LoginResult loginResult = new LoginResult();
		Boolean flag = false;
		try {
			loginResult = contactQueryObject.login();
		} catch (Exception e) {
			flag = true;
			e.printStackTrace();
			throw e;
		}
		if (!flag) {
			if (contactQueryObject.setConfigure(loginResult)) {
				SObject[] contactList = null;
				contactList = contactQueryObject.getQueryResult(contactQueryObject.getQuery()).getRecords();
				assertEquals(20,contactList.length);
			}
		}
	}

}