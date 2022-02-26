/**
 * Class for REST API callout to OpenWeatherMap
 */

public class OpenWeatherClass {
  	private static String ENDPOINT = 'https://api.openweathermap.org/data/2.5/weather?q=';
  	private static String APIKEY = '86c96a15e5e9bb4f17d791a98860cb97';
    public static String APPID = '&appid=';
    public static String GET_METHOD = 'GET';
    public static Integer SUCCESS_STATUS = 200;

    /**
     * @param cityName - account's current billing city
     * @return WeatherInfo - weather information received
     */
    public static WeatherInfo getCalloutByCityName(String cityName) {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      String endpoint = ENDPOINT + cityName + APPID + APIKEY;
      request.setEndpoint(endpoint);
      request.setMethod(GET_METHOD);
      HttpResponse response = http.send(request);
      if(response.getStatusCode() == SUCCESS_STATUS) {
          WeatherInfo result = (WeatherInfo) JSON.deserialize(response.getBody(), WeatherInfo.class);
          return result;
      } else throw new StatusCodeException('Status code is : ' + response.getStatusCode());
	}
        
    /**
     * @param accountsToCheck - list of accounts to process
     * @param cities - list of cities
     * @return accountsToUpdateList - list of accounts to update
     */
    public static List<Account> getAccountsToUpdateForWeatherChange(List<Account> accountsToCheck, Set<String> cities){
        Map<String,String> cityAndDescriptionMap = new Map<String,String>();
        List<Account> accountsToUpdateList = new List<Account>();
        
        //Multiple accounts can have the same BillingCity which lowers the number of callouts
        for(String cityName:cities){
            WeatherInfo weatherDescription = getCalloutByCityName(cityName);
            cityAndDescriptionMap.put(cityName,weatherDescription.weather[0].description);
        }
        
        //Only return accounts with updated weather condition
        for(Account accountRecord:accountsToCheck){
            String cityWeatherDescription = cityAndDescriptionMap.get(accountRecord.BillingCity);
            if(accountRecord.Account_Current_Weather__c != cityWeatherDescription){
                accountRecord.Account_Current_Weather__c = cityAndDescriptionMap.get(accountRecord.BillingCity);
                accountsToUpdateList.add(accountRecord);
            }
        }
        return accountsToUpdateList;
    }
    
    public class StatusCodeException extends Exception {}

    //Deserialize JSON data into apex class WeatherInfo
    public class WeatherInfo{
        public CoordClass coord;
        public WeatherClass[] weather;
        public String base;
        public MainClass main;
        public Integer visibility;
        public WindClass wind;
        public WindCloudsClass clouds;
        public Integer dt;
        public SYSClass sys;
        public Integer timezone;
        public Integer id;
        public String name;
        public Integer cod;
    }
    public class CoordClass {
        public Double lon;
        public Double lat;
    }
    public class WeatherClass {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }
    public class MainClass {
        public Double temp;
        public Double feels_like;
        public Double temp_min;
        public Double temp_max;
        public Integer pressure;
        public Integer humidity;
    }
    public class WindClass {
        public Double speed;
        public Integer deg;
        public Double gust;
    }
    public class WindCloudsClass {
        public Integer all;
    }
    public class SYSClass {
        public Integer type;
        public Integer id;
        public String country;
        public Integer sunrise;
        public Integer sunset;
    }
}