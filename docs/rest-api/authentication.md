# Authentication

To access any resource provided by the sipgate REST API,  you have to send credentials with every request. How these credentials look like depends on the authentication method you choose. 

 
sipgate currently offers [Basic Authentication](#basic-auth) and [OAuth2](#oauth2). Basic Authentication is very convenient and easy to implement. Applications that need to read or write private information using the API on behalf of another user should use OAuth2. 


## Basic Auth

Basic Auth is an easy to use, well known and well supported authentication method. There is a lot of documentation about this authentication method in the internet, e.g: [Wikipedia](https://de.wikipedia.org/wiki/HTTP-Authentifizierung#Basic_Authentication) or [RFC 2617](https://www.ietf.org/rfc/rfc2617.txt).

To use Basic Auth, you simply have to provide an Authorization header with each request. The header takes the keyword `Basic` followed by a blank and a credential string. The credentials string is `username:password` Base64 encoded. 

E.g., if your username was `John` and your password was `topsecret`, your plaintext credentials string would be `John:topsecret`. The Base64 encoded string would be `Sm9objp0b3BzZWNyZXQ=`.  

The complete Header would look like:

``` 
Authorization: Basic Sm9objp0b3BzZWNyZXQ=
```

Example:
```bash
curl \
  --request GET \
  --header "Accept: application/json" \
  --user <your_sipgate_username>:<your_sipgate_password> \
  https://api.sipgate.com/v2/account
```


## OAuth2

OAuth2 is an authentication method that enables a service provider to handle foreign customers sipgate credentials trustworthy. As about Basic Auth, there is a lot of reading about OAuth2 in the net. It is formally specified in [rfc 6749](https://tools.ietf.org/html/rfc6749).


### General authentication flow

TODO: Explain scopes

Since the authentication with OAuth2 tends to confuse people, we start with a few lines of general background information.
 
First thing to understand the authorization process is identifying the three parties involved: 

1. Service provider: The service provider delivers value to its users. These users own resources at another service - the resource provider. Assumed that you are service provider in our case, "you" means the service provider below. 
3. Resource owner: The resource owner uses services delivered by the service provider and owns resources hosted by the resource provider. The resource owner is called the "user" below.  
2. Resource provider: The resource provider maintains resources that belong to the resource owner. sipgate is the resource provider in our case and "we" or "sipgate" refers to the resource provider below. 

To use OAuth2 you need special client credentials to authenticate your application against our authentication system. You can get these credentials in less than 5 minutes - please refer to the [sipgate console documentation]() to learn how. 

The OAuth2 authentication flow consists of several steps. 

1. Send your user to the initial authentication screen provided by sipgate. 
2. The authentication system redirects the user back to your application and provides you a nonce, a use once code. 
3. Take this code along with your client credentials and send them to the authentication system. 
4. The authentication system provides you an access token and a refresh token. The access token grants you access to your users resources for a few minutes. 
5. If the access token lifespan comes to the end, you can take the refresh token to request a fresh access token from out authentication system.

### OAuth2 in the real life

As stated above, the first things you need are client credentials. You can get them at the [sipgate console](https://console.sipgate.com). Learn [here](), how to use the console.

#### Use a ready to use library

Since OAuth2 is standardized and well supported, there are a lot of libraries covering the authentication process for any language. To save time and reduce the risk of potential security failures, we highly encourage you to use such libraries. 

TODO: List some libraries

#### Step 1: Sending the user to our authentication system

The authentication screen is accessible at: 

    https://api.sipgate.com/login/third-party/protocol/openid-connect/auth

The URL must contain some mandatory query parameters: 

- client_id: Your client id, something like 2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e
- redirect_uri: The uri we should send the user after the authorization. Something like https://your.application.com/authorize
- scope: Scopes the user should grant access to, e.g: balance:read
- response_type: Always 'code'

Example URL: 

    https://api.sipgate.com/login/third-party/protocol/openid-connect/auth?client_id=2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e&redirect_uri=https%3A%2F%2Fyour.application%2Fauthorize.com&scope=balance%3Aread&response_type=code
  
Generate the URL with Javascript: 
  
    const apiAuthUrl = 'https://api.sipgate.com/login/third-party/protocol/openid-connect/auth'
      + queryString.stringify({
          client_id: '2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e',
          redirect_uri: 'https://your.application.com/authorize',
          scope: 'balance:read',
          response_type: 'code',
      });  

If redirected to the authentication screen, the user can login into the authorization system with his sipgate username and password. 

![Login screen](../img/login_screen.png)

If successfully authenticated, the user will be asked to grant the requested access scopes. Note that the user needs to give his grant only once as long as the scopes do not change.

![Grant screen](../img/grant_screen.png)

Granting the requested scopes finishes the user interaction and leads to step 2. 

#### Step 2: Get the code ####

The authentication system appends an single use code as query string to the previously provided redirect uri and redirects the user to the resulting location. 

The resulting URL looks like:

    https://your.application.com/?code=2Eamxyz7vQLiHyGqklDox5l1NIDaJ0Fd08ngBaeVNtM.0714e913-f108-4e45-8ad4-976d39dfe0c2
 
You can take this code and build your request for step 3. 

#### Step 3: Request access and refresh token ####

To request access and refresh tokens for the user, you need to send your client credentials and the previously fetched code to the authentication system. To get the tokens you have to post against: 

    https://api.sipgate.com/login/third-party/protocol/openid-connect/token

The parameters you need to provide form encoded are: 

- client_id: Your client id, something like 2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e
- client_secret:  Your client id, something like a1138f1-7-dc848ae6-99aa-23ed-23a4-b7da6846f141
- code: 2Eamxyz7vQLiHyGqklDox5l1NIDaJ0Fd08ngBaeVNtM.0714e913-f108-4e45-8ad4-976d39dfe0c2
- redirect_uri: The location the authorization system should redirect the post request. Something like https://your.application.com
- grant_type: Always 'authorization_code'


    const authorizationCode = req.query.code;
    const apiTokenUrl = "https://api.sipgate.com/login/third-party/protocol/openid-connect/token";
    
    request.post({
      url: apiTokenUrl,
      form: {
        client_id: 'YOUR_API_CLIENT_ID',
        client_secret: 'YOUR_API_CLIENT_SECRET',
        code: authorizationCode,
        redirect_uri: 'http://localhost:3000/authorize',
        grant_type: 'authorization_code',    
      },
    })
      .then(function (body) {
        const response = JSON.parse(body);
        req.session['accessToken'] = response['access_token'];
        res.redirect('/');
      })
      .catch(function () {
        res.redirect(apiAuthUrl);
      });
