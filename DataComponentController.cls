public class DataComponentController {
    
    public Integer size{get;set;}
    public String sortField {get;set;}
    public String myOrder {get;set;}
    
    public ApexPages.StandardSetController setCon{get; set;}
    
    public List<Opportunity> opportunities {
        get  
        {  
            if(setCon != null)  
                return (List<Opportunity>)setCon.getRecords();  
            else  
                return null ;  
        }  
        set;
    }
    
    public DataComponentController() {
        opportunities = new List<Opportunity>();
        sortField = 'Name';
        myOrder = 'ASC';
        toggleSort();	
    }
    
    public void toggleSort() {
        size = 10;
        String queryString = 'SELECT Name, CloseDate, StageName FROM Opportunity ORDER BY '
            + sortField + ' ' + myOrder;
        
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        setCon.setPageSize(size);
        
    }
    
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    public Integer getTotalPages(){
        if(setcon!=null){
            Decimal totalSize = setCon.getResultSize();
            Decimal pageSize = setCon.getPageSize();       
            Decimal pages = totalSize/pageSize;      
            return (Integer)pages.round(System.RoundingMode.CEILING);
        }
        else return null;
    }
    
    public void next(){
        System.debug(setCon.getPageSize());
        if(setCon.getHasNext())
            setCon.next();
    }
    
    public void previous(){ 
        if(setCon.getHasPrevious())
            setCon.previous();           
    }
    public void first() {
        setCon.first();
    }
    
    public void last() {
        setCon.last();        
    }
}