/**
 * Batch job for updating the Account's current weather description
 */
public class AccountsUpdateBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext jobId) {
        return Database.getQueryLocator([SELECT Id, BillingCity, Account_Current_Weather__c from Account WHERE BillingCity != '']);
    }
    
    public void execute(Database.BatchableContext jobId, List<Account> accountsToProcessList){
        Set<String> citiesSet = new Set<String>();
        for(Account accountRecord:accountsToProcessList){
            citiesSet.add(accountRecord.BillingCity);
        }
        List<Account> accountsToUpdateList = OpenWeatherClass.getAccountsToUpdateForWeatherChange(accountsToProcessList,citiesSet);        
        update accountsToUpdateList;
    }
    
    public void finish(Database.BatchableContext jobId){
        //do nothing -> send email notification in case of failure
    }
}