# Peaceful Minds Backend

```diff
- DO NOT USE MY ENDPOINTS INCORRECTLY. MAKE SURE YOU PUT IN THE CORRECT VALUES THAT ACTUALLY EXIST.
- THERE IS A GOOD CHANCE THAT MY SERVER WILL BREAK BECAUSE THERE IS NO ERROR CHECKING
``` 
:sob::sob::sob::sob:
``` diff
- JUST LMK AND I CAN RESTART THE SERVER
```
:thumbsup::thumbsup::thumbsup:
## Viewing the Database from Firebase
All the members have been sent an invitation to view the fake database created in Firebase
to access it simply go to [link](https://console.firebase.google.com)
* sign-in using the gmail account, the invite was sent to
* click on the project **firebase-auth-test**
* on the left hand pane click on **database**
* then choose **Cloud Firestore**, NOT **Real Time Database**
* voila (don't be afraid to click stuff, you won't destroy the database. \**fingers crossed*\*)

## A Little Bit about the Database so you can use my endpoints
Currently the database has 3 collections
* hospital
* insurance_providers
* users

Disclaimer: This is my first time using a NOSQL database, so it might not be the most efficient implementation

There are 10 hospitals, these are their current names:
```
[hospital_0,hospital_1,hospital_2,hospital_3,hospital_4,hospital_5,hospital_6,hospital_7,hospital_8,hospital_9]
```
There are 3 insurance providers, these are their current names:
```
[ip_1,ip_2,ip_3]
```
There are only 3 procedures in total, and all hospital services all 3. Their current names are:
```
[procedure_1,procedure_2, procedure_3]
```
A **user** has the following properties:
```
{
  deductible: integer,
  insurance_id: string,
  password: string,
  username: string,
  zipcode: integer
} 
```
### Don't forget this about insurance ids!
Since I am creating the fake database, ADHERE TO MY RULES! MUAHAHAHA\
Insurance Providers will provide multiple insurance plans, depending on what the customer is subscribed to\
Currently there are only 2 plans per insurance provider in my fake database.\
Therefore, I'm using the last digit of the insurance id to specify which insurance plan.\
If the last digit ends with **0**, the user is subscribed to plan_1 of the insurance provider.
Otherwise, the user is subscribed to plan_2

e.g.
```
U9YT65420Y
```
In this example, the user is subscribed to *plan_2* because the last character is **Y**

## Something to look out for
anytime you see something like this:
```
/:keyword
```
the ':keyword' is a placeholder for a value you're supposed to fill. It means that you're supposed to replace ':keyword'\
e.g.
```
/:hospital
```
becomes
```
/Ronald_Reagan_UCLA
```

## Alright, let's look at the endpoints and get our hands dirty
### Domain
```https://peaceful-minds.herokuapp.com```

### Creating a new user
To create a new user you need the following information:
* username
* password
* zipcode
* insurance_id
* insurance_provider

endpoint:
```
/add_user/:username/:password/:zipcode/:insurance_id/:insurance_provider
```
e.g. (this is something you put in your browser)
```
https://peaceful-minds.herokuapp.com/add_user/ronaldreagan/happyreagan123/90024/PO1238y0/ip_1
```
this will add a user with the 
* username: ronaldreagan
* password: happyreagan123
* zipcode: 90024
* insurance_id: PO1238y0
* insurance_provider: ip_1

If the account is successfully created, you will see a
```
ronaldreagan account created
```
you will then see a new user entry in the firebase console, as it is updated automatically

**Reminder:** It is very important that you use the available names for hospital and insurance_provider, because there is no error checking!
### Extracting Information for All Hospitals 
We will extract the necessary information to create our table of results, given a username and a procedure

endpoint:
```
/:username/:procedure
```
e.g.
```
https://peaceful-minds.herokuapp.com/ronaldreagan/procedure_2
```
The following is a sample output of what you might see:
```javascript
[{"part1":[{"price":100,"name":"s1","i_adj":50,"post_adj":50},{"price":200,"name":"s2","i_adj":120,"post_adj":80},{"name":"s3","price":300,"i_adj":210,"post_adj":90}],"part_2":{"total_post_adj":220,"deductible":50,"insurance_coverage":"50%","isDeductibleLessThan":true,"total_owe":135,"isInNetwork":true}},{"part1":[{"price":100,"name":"s1","i_adj":40,"post_adj":60},{"price":200,"name":"s2","i_adj":96,"post_adj":104},{"price":300,"name":"s3","i_adj":168,"post_adj":132}],"part_2":{"total_post_adj":296,"deductible":50,"insurance_coverage":"40%","isDeductibleLessThan":true,"total_owe":148.4,"isInNetwork":false}}, ... ]
```
The output shown is in a JSON format. Please do not let the curly braces intimidate you.:kissing_heart:\
you can simply go to this [link](https://jsonformatter.curiousconcept.com/) and paste the JSON text there\
so you can see it more clearly

### Extracting Information for a specific Hospital
This will display the same information as the one above but for only the hospital specified

endpoint:
```
/:username/:procedure/:hospital
```
e.g.
```
https://peaceful-minds.herokuapp.com/ronaldreagan/procedure_2/hospital_8
```
The following is a sample output of what you might see:
```javascript
{"part1":[{"price":100,"name":"s1","i_adj":50,"post_adj":50},{"price":200,"name":"s2","i_adj":120,"post_adj":80},{"name":"s3","price":300,"i_adj":210,"post_adj":90}],"part_2":{"total_post_adj":220,"deductible":50,"insurance_coverage":"50%","isDeductibleLessThan":true,"total_owe":135,"isInNetwork":true}}
```
