# Peaceful Minds Backend

## Viewing the Database from Firebase
All the members have been sent an invitation to view the fake database created in Firebase
to access it simply go to [link](https://console.firebase.google.com)
* sign-in using the gmail account, the invite was sent to
* click on the project **firebase-auth-test**
* on the left hand pane click on **database**
* then choose **Cloud Firestore**, NOT **Real Time Database**
* voila

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
## Alright, let's look at the endpoints and get our hands dirty

### Something to look out for
anytime you see something like this:
```
/:keyword
```
the ':keyword' is a placeholder for a value you're supposed to fill
it means that you're supposed to replace ':keyword'
e.g.
```
/:hospital
```
becomes
```
/Ronald_Reagan_UCLA
```

### Creating a new user
To create a new user you need the following information:
* username
* password
* zipcode
* insurance_id
* insurance_provider

endpoint:
```
website.com/add_user/:username/:password/:zipcode/:insurance_id/:insurance_provider
```
e.g.
```
website.com/add_user/ronaldreagan/happyreagan123/90024/PO1238y0/ip_1
```
this will add a user with the 
* username: ronaldreagan
* password: happyreagan123
* zipcode: 90024
* insurance_id: PO1238y0
* insurance_provider: ip_1

**Reminder:** It is very important that you use the available names for hospital and insurance_provider, because there is no error checking!
