# Authentication

## Simple authentication for scripts using Basic Auth

If you simply want to access your own data through the API you do not have to use oAuth authorization delegation. Simply use [Basic Auth](https://tools.ietf.org/html/rfc2617#section-2) to access our API.

**Attention:** Never use Basic Auth, if you want to access the data of someone else in your app.

To get basic information about your account you can query the [/account](ref:getaccount-1) route:

```bash
curl \
--request GET \
--header "Accept: application/json" \
--user <your_sipgate_username>:<your_sipgate_password> \
https://api.sipgate.com/v2/account
```

Or you could send an SMS:
```bash
curl \
--request POST \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--user <your_sipgate_username>:<your_sipgate_password> \
--data '{"smsId": "<your_sms_id>", "recipient": "<phone_number>", "message": "I :love: sipgate!"}' \
https://api.sipgate.com/v2/sessions/sms
```


## Authenticating users in third party applications 

When building a third-party application users will have to authorize via the OAuth authorization code flow. 
Refer to our guide about [managing third-party clients](doc:managing-third-party-clients-using-the-command-line) to learn how to obtain a `clientId` and `clientSecret`. After that your application will be able to query the sipgate REST API.  

During the authorization process the user will be asked to grant permission to your client to access the REST API. The user will have the option to allow the access or cancel the authorization process.

![Grant screen](../img/grant_screen.png)

You can find an example of how to implement this authorization flow in our [rest api example](/v2.0/docs/building-a-third-party-application-using-oauth-clients).
