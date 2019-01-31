import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.enterprise.SaveResult;
import com.sforce.soap.enterprise.sobject.Student__c;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;


public class InsertStudent {

	public static ConnectorConfig config = new ConnectorConfig();

	public EnterpriseConnection connection;

	public static LoginResult login() throws ConnectionException {
		final String USERNAME = "ajayrock1997@curious-otter-fvvjjo.com";
		final String PASSWORD = "akv@19973flawk0VhsUzbLqraYRABMnXG";
		final String URL = "https://login.salesforce.com/services/Soap/c/44.0";
		final LoginResult loginResult = loginToSalesforce(USERNAME, PASSWORD, URL);
		return loginResult;
	}

	private static LoginResult loginToSalesforce(final String username, final String password, final String loginUrl)
			throws ConnectionException {
		config = new ConnectorConfig();
		config.setAuthEndpoint(loginUrl);
		config.setServiceEndpoint(loginUrl);
		config.setManualLogin(true);
		LoginResult loginResultObj = new EnterpriseConnection(config).login(username, password);
		return loginResultObj;
	}
	
	public Boolean setConfigure(LoginResult loginResult) {
		Boolean flag = true;
		try {
			config.setServiceEndpoint(loginResult.getServerUrl());
			config.setSessionId(loginResult.getSessionId());
			connection = new EnterpriseConnection(config);
		} catch (ConnectionException e) {
			flag = false;
			e.printStackTrace();
		}
		return flag;
	}
	
	public SaveResult[] insertStudents(Student__c[] listOfStudents) {
		SaveResult[] saveResult = null ;
		try {
			System.out.println("\nInserting...\n");
			saveResult = connection.create(listOfStudents);
		} catch (ConnectionException ce) {
			ce.printStackTrace();
			System.out.println("\nStudents insertion failed.");
		}
		return saveResult;
	}
	
}