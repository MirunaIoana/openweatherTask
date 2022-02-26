/**
 * Account trigger handler class
 */
public class AccountTriggerHandler {
    
    public void onUpdate(List<Account> newAccounts, Map<Id, Account> oldAccounts){
        updateAccountRecordsAddress(newAccounts,oldAccounts);
    }
    
    public void onInsert(List<Account> newAccounts){
        updateAccountRecordsAddress(newAccounts,new Map<Id, Account>());
    }
    
    /**
     * When account gets inserted or BillingCity is updated, it will update the Account_Current_Weather__c field 
     * 
     * @param newAccounts - list of all accounts that are updated/inserted
     * @param oldAccounts - old version of accounts map 
     */
    public void updateAccountRecordsAddress(List<Account> newAccounts, Map<Id, Account> oldAccounts){
        Set<Id> setIdsAccountsToUpdate = new Set<Id>();
        Set<String> setCities = new Set<String>();
        
        for(Account accountRecord:newAccounts){
            if(!String.isBlank(accountRecord.BillingCity)){
                setCities.add(accountRecord.BillingCity);
                if(!(oldAccounts == null) && oldAccounts.get(accountRecord.Id) != null){
                    Account oldAccountRecord = oldAccounts.get(accountRecord.Id);
                    if(accountRecord.BillingCity != oldAccountRecord.BillingCity){
                        setIdsAccountsToUpdate.add(accountRecord.Id);
                    }
                } else if(String.isBlank(accountRecord.Account_Current_Weather__c)){
                    setIdsAccountsToUpdate.add(accountRecord.Id);
                }
            }
        }

        if(!System.isFuture() && !System.isBatch() && !setIdsAccountsToUpdate.isEmpty()){
        	updateAccountsWeather(setIdsAccountsToUpdate, setCities);
        }
    }
    
    /**
     * To execute callout from trigger, future method updateAccountsWeather is used
     * 
     * @param accountsToUpdate - set of all accounts to update/insert
     * @param citiesSet - set of cities used to get weather description 
     */
    @future(callout=true)
    public static void updateAccountsWeather(Set<Id> accountsToUpdate, Set<String> citiesSet){
        List<Account> accountsList = [SELECT Id, BillingCity, Account_Current_Weather__c FROM Account WHERE Id IN :accountsToUpdate];
        List<Account> accountsToUpdateList = OpenWeatherClass.getAccountsToUpdateForWeatherChange(accountsList,citiesSet);        
        update accountsToUpdateList;
    }
}