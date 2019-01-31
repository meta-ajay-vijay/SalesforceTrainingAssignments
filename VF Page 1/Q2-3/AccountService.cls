public class AccountService {
    public String getCondition(String billingCountry, String billingState, String billingCity) {
        System.debug('Service billingCountry: ' + billingCountry);
        System.debug('Service billingState: ' + billingState);
        System.debug('Service billingCity: ' + billingCity);
        String condition='';
        if(billingCountry != null && !('').equals(billingCountry)){
            condition = condition + 'BillingCountry Like \'%'+billingCountry+'%\'';
        }
        if(billingCity != null && !('').equals(billingCity)){
            if(! ('').equals(condition)){
                condition = condition + ' And';
            }
            condition = condition + ' BillingCity Like \'%'+billingCity+'%\'';   	
        }
        if(billingState != null && !('').equals(billingState)){
            if(! ('').equals(condition)){
                condition = condition + ' And';
            }
            condition = condition + ' BillingState Like \'%'+billingState+'%\'';   	
        }
        System.debug('Service Condition: ' + condition);
        return condition;
    } 
}