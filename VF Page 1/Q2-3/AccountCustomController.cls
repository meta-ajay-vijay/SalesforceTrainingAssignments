public class AccountCustomController {
    private Account acc;
    public AccountService accountServiceObj = new AccountService();
    Transient private AccountSelector accountSelectorObj = new AccountSelector();
    
    public List<Account> accountList {get; set ;}
    
    public String billingCountry {get ; set ;}
    public String billingCity {get ; set ;}
    public String billingState {get ; set ;}
    public Boolean showResult {get; set;}
    public Boolean getData = true;
    
    public ApexPages.StandardSetController setController {
        get {
            if(getData) {
                AccountSelector accountSelectorObj1 = new AccountSelector();
                String condition = accountServiceObj.getCondition(billingCountry,billingState,billingCity);
                setController = new ApexPages.StandardSetController(accountSelectorObj1.getAccounts(condition));
                setController.setPageSize(10);
                showResult = (setController.getResultSize() > 0) ? true : false ;
            }
            return setController;
        }
        private set;}
    public AccountCustomController() {}
    
    public AccountCustomController(ApexPages.StandardSetController setController) {
        //acc = (Account) setController.getRecord();
        changeGetDataStatus(true);
        setAccountList();
        changeGetDataStatus(false);
    }
    
    //Testing Done
    public void setAccountList() {
        accountList = getAccountList();
    }
    
    //Testing Done
    public List<Account> getAccountList() {
        return (List<Account>) setController.getRecords();
    }
    
    //Testing Done
    public void searchAccounts() {
        changeGetDataStatus(true);
        setAccountList();
        changeGetDataStatus(false);
    }
    
    private void changeGetDataStatus(boolean status) {
        getData = status;
    }
    
    //Testing Done
    public void nextPage(){
        if(setController!=null){
            if(setController.getHasNext()){
                setController.next();
                setAccountList();
            }
        }
    }
    
    //Testing Done
    public void previousPage(){
        if(setController!=null){
            if(setController.getHasPrevious()){
                setController.previous();
                setAccountList();
            }
        }
    }
    
    //Testing Done
    public void firstPage(){
        if(setController!=null){
            setController.first();
            setAccountList();
        }
    }
    
    //Testing Done
    public void lastPage(){
        if(setController!=null){
            setController.last();
            setAccountList();
        }
    }
}