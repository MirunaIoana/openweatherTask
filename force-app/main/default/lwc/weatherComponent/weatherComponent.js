import { LightningElement,api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue} from 'lightning/uiRecordApi';

import BILLING_STREET from '@salesforce/schema/Account.BillingStreet';
import BILLING_CITY from '@salesforce/schema/Account.BillingCity';
import BILLING_COUNTRY from '@salesforce/schema/Account.BillingCountry';
import BILLING_POSTALCODE from '@salesforce/schema/Account.BillingPostalCode';
import BILLING_STATE from '@salesforce/schema/Account.BillingState';

const FIELDS = [BILLING_POSTALCODE, BILLING_COUNTRY, BILLING_CITY,BILLING_STREET,BILLING_STATE];
const ENDPOINT = 'https://api.openweathermap.org/data/2.5/weather?q=';
const APIKEY = '86c96a15e5e9bb4f17d791a98860cb97';
const APPID = '&appid=';

export default class WeatherComponent extends LightningElement {
    @api recordId;
    @track city;
    street;
    country;
    postalCode;
    state;
    currentWeather;
    isLoaded = false;
    isWeatherFetched = false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record({ error, data }) {
        if(data){
            this.city = getFieldValue(data, BILLING_CITY);
            this.street = getFieldValue(data, BILLING_STREET);
            this.country = getFieldValue(data,BILLING_COUNTRY);
            this.postalCode = getFieldValue(data,BILLING_POSTALCODE);
            this.state = getFieldValue(data,BILLING_STATE);
            this.handleFetch();
        }
    }

    get loadWeatherComponent(){
        return(this.isLoaded);
    }

    handleFetch() {
        let endPoint = ENDPOINT + this.city + APPID + APIKEY;
        fetch(endPoint, {
          method: "GET"
        })
          .then((response) => response.json()) 
          .then((weatherInfo) => {
            this.currentWeather = weatherInfo.weather[0].description;
          })
          .catch(error => {
              this.showToast('Error','City is not valid!');
          });
        this.isLoaded = true;
        this.isWeatherFetched = true;
      }

    handleUpdate(event) {
        if(!this.city){
            this.isWeatherFetched = false;
            this.showToast('Error','City cannot be empty!');
        } else {
            this.isWeatherFetched = false;
            this.handleFetch();
        }
    }

    handleChange(event) {
        this.city =  event.target.city;
    }

    showToast(titleLabel, messageError) {
        this.dispatchEvent(new ShowToastEvent({
            title: titleLabel,
            message: messageError,
            variant: 'error',
            mode: 'dismissable'
        }));
    }
}