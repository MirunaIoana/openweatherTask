## Task 1

Address - used BillingAddress (specially BillingCity)
Account Current Weather - created new custom field

Directions were a bit vague and business context wasn't provided, so at first I understood I should also update the Account Current Weather (new custom field) when Address is changed (used BillingAddress as there wasn't that much context). For this I created a trigger on Account that checks when a new record is inserted (with BillingCity filled in) or updated. Later on I understood the focus was more on the LWC.
