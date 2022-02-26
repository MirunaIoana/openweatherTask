/**
 * Test class for OpenWeatherClass
 */

@isTest
private class OpenWeatherClass_TEST {
    private final static String CITY_LONDON = 'London';
    private final static String WEATHER_DESCRIPTION = 'clear sky';
    private final static String WEATHER_DESCRIPTION2 = 'storm';
    private final static String STATIC_RESOURCE_OPEN_WEATHER = 'OpenWeatherMap';
    
    @isTest 
    static void testGetCalloutPositive() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        mock.setStaticResource(STATIC_RESOURCE_OPEN_WEATHER);
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        OpenWeatherClass.WeatherInfo result = OpenWeatherClass.getCalloutByCityName(CITY_LONDON);
        
        System.assertNotEquals(null,result);
        System.assertEquals(WEATHER_DESCRIPTION, result.weather[0].description);
    }
    
    @isTest 
    static void testGetCalloutNegative() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        mock.setStaticResource(STATIC_RESOURCE_OPEN_WEATHER);
        mock.setStatusCode(400);
        
        Test.setMock(HttpCalloutMock.class, mock);
        try{
        	OpenWeatherClass.WeatherInfo result = OpenWeatherClass.getCalloutByCityName('');
        }catch(Exception error){
        	System.assertEquals('Status code is : 400', error.getMessage());
        }
    }
    
    @isTest 
    static void shouldGetAccountsToUpdate() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        mock.setStaticResource(STATIC_RESOURCE_OPEN_WEATHER);
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<Account> listAccountsToProcess = new List<Account>{
            new Account(
                Name = 'Acc1', 
                BillingCity = CITY_LONDON, 
                Account_Current_Weather__c = WEATHER_DESCRIPTION2)};
                    
        List<Account> accountsToUpdate = OpenWeatherClass.getAccountsToUpdateForWeatherChange(listAccountsToProcess,new Set<String>{CITY_LONDON});

        System.assertEquals(1, accountsToUpdate.size());
        System.assertEquals(WEATHER_DESCRIPTION, accountsToUpdate[0].Account_Current_Weather__c);
        
    }   
}