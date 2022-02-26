/**
 * Test class for AccountsUpdateBatch batch class
 */

@isTest
private class AccountsUpdateBatch_TEST {
    private final static String STATIC_RESOURCE_OPEN_WEATHER = 'OpenWeatherMap';
    private final static String WEATHER_DESCRIPTION = 'storm';
    private final static String CITY_LONDON = 'London';
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0 ; i<5 ; i++) {
            Account newAccount = new Account(
            	Name = 'Account' + i,
            	BillingCity = CITY_LONDON,
            	Account_Current_Weather__c = WEATHER_DESCRIPTION);
            accounts.add(newAccount);
        }
        insert accounts;
    }
    @isTest 
    static void testAccountUpdateBatch() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(STATIC_RESOURCE_OPEN_WEATHER);
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        AccountsUpdateBatch batchJob = new AccountsUpdateBatch();
        Id batchId = Database.executeBatch(batchJob,100);
        Test.stopTest();

        Integer updatedAccounts = [SELECT Count() FROM Account WHERE Account_Current_Weather__c = 'clear sky'];
        System.assertEquals(5, updatedAccounts);
    }
}