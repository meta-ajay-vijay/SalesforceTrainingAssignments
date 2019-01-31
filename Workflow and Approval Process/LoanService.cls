public class LoanService {
    public static void insertManagerInLoanEntry(List<Loan__c> recordList){
        System.debug('insertManagerInLoanEntry entry');
        CityManagerSelector cityManagerSelectorObject = new CityManagerSelector();
        Set<String> cityNames = new Set<String>();
        for(Loan__c loanObject : recordList){
            cityNames.add(loanObject.City__c);
        }
        System.debug('Cities: ' + cityNames);
        
        if(cityNames.size() > 0){
            Map<String,CityManager__c> cityManagerMap = new Map<String,CityManager__c>();
            List<CityManager__c> cityManagerList = cityManagerSelectorObject.selectCityManagerByName(cityNames);
            System.debug('cityManagerList' + cityManagerList);
            for(CityManager__c cityManagerObject : cityManagerList){
                cityManagerMap.put(cityManagerObject.City__c,cityManagerObject);
            }
            System.debug('cityManagerMap: '+cityManagerMap);
            for(Loan__c loanObject : recordList){
                CityManager__c cityManagerObject = cityManagerMap.get(loanObject.City__c);
                System.debug('cityManagerObject: ' + cityManagerObject);
                if(cityManagerObject != null){
                    System.debug('cityManagerObject.Manager__c: '+cityManagerObject.Manager__c);
                    loanObject.Manager__c = cityManagerObject.Manager__c;
                }
            }
        }	
    }
}