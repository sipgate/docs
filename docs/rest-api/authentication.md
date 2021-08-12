# Authentication

To access any resource provided by the sipgate REST API,  you have to send credentials with every request. How these credentials look like depends on the authentication method you choose.


sipgate currently offers [Personal Access Token](#personal-access-token) and [OAuth2](#oauth2). Personal Access Token are very convenient and easy to implement. Applications that need to read or write private information using the API on behalf of another user should use OAuth2.


## Personal Access Token

see [https://www.sipgate.io/rest-api/authentication#personalAccessToken](https://www.sipgate.io/rest-api/authentication#personalAccessToken)

## OAuth2

OAuth2 is an authentication method that enables a service provider to handle foreign customers sipgate credentials trustworthy. As about Basic Auth, there is a lot of reading about OAuth2 in the net. It is formally specified in [rfc 6749](https://tools.ietf.org/html/rfc6749).


### General authentication flow

<!-- TODO: Explain scopes -->

Since the authentication with OAuth2 tends to be confusing, here a few lines of what we've learned so far.

First thing to understand the authorization process is identifying three parties:

1. Service provider: The service provider delivers value to its users. These users own resources at another service - the resource provider. The documentation below assumes that you are a service provider, because of that "you" means the part of the service provider in this document.
3. Resource owner: The resource owner uses services delivered by the service provider and owns resources hosted by the resource provider. The resource owner is called the "user" below.
2. Resource provider: The resource provider maintains resources that belong to the resource owner. sipgate is the resource provider in our case and "we" or "sipgate" refers to the resource provider below.

To use OAuth2 you need special client credentials to authenticate your application against our authentication system. You can get these credentials in less than 5 minutes - please refer to the [sipgate console documentation](managing-third-party-clients#web-console) to learn how.

The OAuth2 authentication flow consists of several steps.

1. Send your user to the initial authentication screen provided by sipgate.
2. The authentication system redirects the user back to your application and provides you a nonce, a use once code.
3. Use this code along with your client credentials and send them to the authentication system.
4. The authentication system provides you an access token and a refresh token. The access token grants you access to your users resources for a few minutes.
5. If the access token lifespan comes to the end, you can take the refresh token to request a new access token from out the authentication system.

### OAuth2 in the real life

As stated above, the first things you need are client credentials. You can get them at the [sipgate console](https://console.sipgate.com).  Learn [here](managing-third-party-clients#web-console), how to use the console.

#### Use a ready to use library

Since OAuth2 is standardized and well supported, there are a lot of libraries covering the authentication process for any language. To save time and reduce the risk of potential security failures, we highly recommend to use such libraries.

#### Step 1: Sending the user to our authentication system

The authentication screen is accessible at:

```
    https://login.sipgate.com/auth/realms/REALM/protocol/openid-connect/auth
```

The URL must contain some mandatory query parameters:

- realm: By default an oauth client will be created with a 'sipgate-apps' realm, but older clients can have the 'third-party' realm. You can check the realm your client is using at the [sipgate console](https://console.sipgate.com)
- client_id: Your client id, something like 2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e
- redirect_uri: The uri we should send the user after the authorization. Something like https://your.application.com/authorize
- scope: Scopes the user should grant access to, e.g: balance:read
- response_type: Always 'code'

Example URL:
```
    https://login.sipgate.com/auth/realms/sipgate-apps/protocol/openid-connect/auth?client_id=2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e&redirect_uri=https%3A%2F%2Fyour.application%2Fauthorize.com&scope=balance%3Aread&response_type=code
```

Generate the URL with Javascript:
```js
    const realm = "sipgate-apps";
    const apiAuthUrl = `https://login.sipgate.com/auth/realms/${realm}/protocol/openid-connect/auth?`
      + queryString.stringify({
          client_id: '2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e',
          redirect_uri: 'https://your.application.com/authorize',
          scope: 'balance:read',
          response_type: 'code',
      });
```

If redirected to the authentication screen, the user can login into the authorization system with his sipgate username and password.

![Login screen](../img/login_screen.png)

If successfully authenticated, the user will be asked to grant the requested access scopes. Note that the user needs to grant access only once as long as the scopes do not change.

![Grant screen](../img/grant_screen.png)

Granting the requested scopes finishes the user interaction and leads to step 2.

#### Step 2: Get the code ####

The authentication system appends a single use code as a query string to the previously provided redirect uri and redirects the user to that location.

The resulting URL looks like:
```
    https://your.application.com/?code=2Eamxyz7vQLiHyGqklDox5l1NIDaJ0Fd08ngBaeVNtM.0714e913-f108-4e45-8ad4-976d39dfe0c2
```

You can take this code and build your request for step 3.

#### Step 3: Request access and refresh token ####

To request access and a refresh tokens for the user, you need to send your client credentials and the previously fetched code to the authentication system. To get the tokens you have to send a post request against:

```
    https://login.sipgate.com/auth/realms/REALM/protocol/openid-connect/token
```

The parameters you need to provide, form encoded, are:

- realm: The Realm where your client is established. You can check the realm your client is using at the [sipgate console](https://console.sipgate.com)
- client_id: Your client id, something like 2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e
- client_secret:  Your client secret, something like a1138f1-7-dc848ae6-99aa-23ed-23a4-b7da6846f141
- code: 2Eamxyz7vQLiHyGqklDox5l1NIDaJ0Fd08ngBaeVNtM.0714e913-f108-4e45-8ad4-976d39dfe0c2
- redirect_uri: The location the authorization system should redirect the post request to. Something like https://your.application.com
- grant_type: Always 'authorization_code'

```js
    const realm = "sipgate-apps" 
    const authorizationCode = req.query.code;
    const apiTokenUrl = `https://login.sipgate.com/auth/realms/${realm}/protocol/openid-connect/token`;

    const response = request.post({
      url: apiTokenUrl,
      form: {
        client_id: 'YOUR_API_CLIENT_ID',
        client_secret: 'YOUR_API_CLIENT_SECRET',
        code: authorizationCode,
        redirect_uri: 'http://localhost:3000/authorize',
        grant_type: 'authorization_code',
      },
    })
```

Our authentication system will provide the tokens as response to this query.

#### Step 4: Retrieve access and refresh token ####

The response to the query explained in step 3 looks like this:

```json
{
   "session_state" : "32c512d5-ccf2-4103-9555-a85d924f7d52",
   "token_type" : "bearer",
   "id_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU1sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiI1YWMzYThhMC00NDk5LTRhODAtYjU5OS02NDcwYmJmOWI1YmIiLCJleHAiOjE1MjUyNzIxNDEsIm5iZiI6MCwiaWF0IjoxNTI1MjcxODQxLCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IklEIiwiYXpwIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsImF1dGhfdGltZSI6MTUyNTI3MTgzMCwic2Vzc2lvbl9zdGF0ZSI6IjMyYzUxMmQ1LWNjZjItNDEwMy05NTU1LWE4NWQ5MjRmN2Q1MiIsImFjciI6IjEifQ.NqxGYlsfKwn0t0nJxd0Z-qLk8ZRpJu16YXawvpPd6_1DdrUzBuZSXN-at8mgZhozjyAdlopmkIpgXUbNL0S7_VsgR_3dkKA4BxDyzVIpeOJlZw4ARFFuO22wpWp49Fg_4PNOcvSLzmGnrLXJIxkQ-si0fRa597NiisQ_tJZfcu55hpu1knS-3TZZman5Of7vuaPJozvvib6fmwBYgS0FtzBGMvEnJZjzJkvUgLe284iPNWfbP6h70MUqa9AqsL1EPYHJj96LOer9STpDQp9WfxEWBrAAsI9aufs1Cf643RnXpvo7J0mNpjodZA28BNK5bZFRnwsEHmEe_2-VHqYtaA",
   "refresh_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU1sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiJiOTEzZjRmMC05MjhmLTRkMTYtOGNjMC00NjI5M2JmYWRjNDIiLCJleHAiOjE1Mjc4NjM4NDEsIm5iZiI6MCwiaWF0IjoxNTI1MjcxODQxLCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiIyNDc3MTQ4LTAtNzQ3NWI4ZDItNGUxMi0xMWU4LWE5NTctYjMxYWZkNzY3MWIyIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiMzJjNTEyZDUtY2NmMi00MTAzLTk1NTUtYTg1ZDkyNGY3ZDUyIiwiY2xpZW50X3Nlc3Npb24iOiJkNjI5ZTU0MC0yNTAzLTRiMmEtOTI5MS03MjYxYjgyMzAwYTEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiYmFsYW5jZTpyZWFkIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.V93zXtLdDisdsrq-I8hLspR60SlnLC5Wt_8w5Sq4Wi3P21WZfYBgIVHfeC0hcKSRIFlvuCx0tdeWNIV7L3YGUARWyk074kUTz6ZgcPM3OVNtjK-124odkhFK7IN8GRMBWeOzgvjqzkekNJHZ9IH4A7WbOaitQzMJmt_bl0J-GoTww_07kRUhiBY_tJrECAh6qvK_uYsNIzfzOZ2jcFYKUH6SQuwFt5EmcHck0awRBpemSVAP-LshW6ZyETuoiNsJaYjKoNqHUcjvqzX9syevasd2eKAi_LQo2WBzMLszLRyz6AC1KfuzsJelvMMzDc9DBi7Pum5Tl_jTp2YoolW5iA",
   "access_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU1sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiI4MzM3N2RjZC0xOTU5LTQwMzYtYjhlZi0wMTRhYzk2ZTQ4NmIiLCJleHAiOjE1MjUyNzIxNDEsIm5iZiI6MCwiaWF0IjoxNTI1MjcxODQxLCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjI0NzcxNDgtMC03NDc1YjhkMi00ZTEyLTExZTgtYTk1Ny1iMzFhZmQ3NjcxYjIiLCJhdXRoX3RpbWUiOjE1MjUyNzE4MzAsInNlc3Npb25fc3RhdGUiOiIzMmM1MTJkNS1jY2YyLTQxMDMtOTU1NS1hODVkOTI0ZjdkNTIiLCJhY3IiOiIxIiwiY2xpZW50X3Nlc3Npb24iOiJkNjI5ZTU0MC0yNTAzLTRiMmEtOTI5MS03MjYxYjgyMzAwYTEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiYmFsYW5jZTpyZWFkIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.a3KJmOlfajPsPIXTUGwKbdCzIKDybgCO5NnfWyIVaFQ0M_U9SsqrEbErXgMKauYBRyQagvxvNvVKCcH-iS4Uzai7HXonHCnYG6Yt4mrRAWkFNw9hrvVWQIcuZgHew0YP8OBfFmvfbFR4I8DsdVCI58zqBDBSH-ZCTu1sK1FIrHKtWzqjHesxaqYPT2iz6d0MIKtdR5CKN4oO_FYzlCHEBvdIIUjNTp3k4KmUGzoMhHcSpqiLquylnc5IfeD57z50Ay4pUkzHO7K-mw9cMoZ1RscAnKC5oPoepuZkXzBAK5XYa5xZMa4GhWBaKKokG1GpaIuoOJ55lilMoXYtz3yODg",
   "not-before-policy" : 0,
   "expires_in" : 300,
   "refresh_expires_in" : 2592000
}
```

The following snippet shows the request from step 3 and extracts the access code out of the response.

```js
const realm = "sipgate-apps"
const authorizationCode = req.query.code;
const apiTokenUrl = `https://login.sipgate.com/auth/realms/${realm}/protocol/openid-connect/token`;

const response = request.post({
  url: apiTokenUrl,
  form: {
    client_id: 'YOUR_API_CLIENT_ID',
    client_secret: 'YOUR_API_CLIENT_SECRET',
    code: authorizationCode,
    redirect_uri: 'http://localhost:3000/authorize',
    grant_type: 'authorization_code',
  },
}).then(function (body) {
  const response = JSON.parse(body);
  req.session['accessToken'] = response['access_token'];
  res.redirect('/');
})
.catch(function () {
  res.redirect(apiAuthUrl);
});
```

Now you are ready to access the sipgate api. To do so, you have to send the `access token` as authorization header. If your access code was f123b4214b3124312b, the header would be:

```
  Authorization: Bearer f123b4214b3124312b
```

#### Step 5: Refresh the access token ####

Due to security reasons, the access token obtained in step 4 has a very limited lifetime of usually 5 minutes. To prevent your user from logging in every 5 minutes, OAuth2 provides a token refresh mechanism. To get a new `access token`, you have to send the corresponding `refresh token` as well as your `client id` and `client secret` to our authentication system at:

```
    https://login.sipgate.com/auth/realms/REALM/protocol/openid-connect/token
```

Provide following data form encoded within a POST request:

- realm: The Realm where your client is established. You can check the realm your client is using at the [sipgate console](https://console.sipgate.com)
- client_id: Your client id, something like 2556404-0-dc848ae6-085c-11e8-92a6-31b99c83912e
- client_secret:  Your client secret, something like a1138f1-7-dc848ae6-99aa-23ed-23a4-b7da6846f141
- refresh_token: The refresh token corresponding to the expiring access token.
- grant_type: Always `refresh_token`

A request could be sent this way:

```
curl \
  --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Accept: application/json' \
  --data-urlencode "client_id=2566404-0-db848ab6-085c-11e8-97a6-31b99b83912e" \
  --data-urlencode "client_secret=a1138f1-7-dc848ae6-99aa-23ed-23a4-b7da6846f141" \
  --data-urlencode "refresh_token=eyJhbGciOiJSUzI1NiIsInR5cCIgOiA[...]WDVWn1dj7kQ8_wVgmxg" \
  --data-urlencode "grant_type=refresh_token" \
  https://login.sipgate.com/auth/realms/sipgate-apps/protocol/openid-connect/token
```

Our authentication system will provide a new set of `access token` and `refresh token` with a response like the following:

```json
{
   "refresh_expires_in" : 2592000,
   "id_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU1sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiJkYzQ2N2FjYi1hYjg0LTQ1MDctYmM5OC0yOWE2NmRmN2U5NTQiLCJleHAiOjE1MjUyNzY4NTQsIm5iZiI6MCwiaWF0IjoxNTI1Mjc2NTU0LCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IklEIiwiYXpwIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsImF1dGhfdGltZSI6MTUyNTI3NjM5OSwic2Vzc2lvbl9zdGF0ZSI6Ijk0MWI0NGRjLWNiYzktNDhkYi1iNDc5LTE3NDFjNGNkOTU0MCIsImFjciI6IjEifQ.T_E7VOk_g_U-Uw4ySjsnr_SlIwbglb5R9PxJ-nvSYIaNlu651OVbQEv_X3EJZuTedAVBOxLPSxZjH_HY5pKAZeoBXwThf70YbbVVJOKrdDUr1E68qzrpFfghB12iVXoEIv2SruJxelRaFW7v-CyaktjemXEDcScrYgUGGij07mwSBxGKbkeGpq68S535HDixhPTfpXyDRy69Nm-rsP1j4c3t4Ja_6I7runb9XC7rIU7BOU07TtM2yHdEkBbDsUOinSf9gQYAz69dUdEpAHk1h4pz3dassYVmUhfRzWDe0SiP1fUpJFgF-wGYOBFoVGYYKGRyx2VI_ZyS2jJb8XOZAQ",
   "session_state" : "941b44dc-cbc9-48db-b479-1741c4cd9540",
   "not-before-policy" : 0,
   "expires_in" : 300,
   "refresh_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU1sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiJkYzkxY2M5ZS0xMGU1LTQ3ZjEtYWM5OC1wZjEyNGM1NjUxZmUiLCJleHAiOjE4Mjc4Njg1NTQsIm5iZiI6MCwiaWF0IjoxNTI1Mjc2NTU0LCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiIyNDc3MTQ4LTAtNzQ3NWI4ZDItNGUxMi0xMWU4LWE5NTctYjMxYWZkNzY3MWIyIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiOTQxYjQ0ZGMtY2JjOS00OGRiLWI0NzktMTc0MWM0Y2Q5NTQwIiwiY2xpZW50X3Nlc3Npb24iOiIxZWM2M2MwZC1kOTFkLTRmZmItOTM5Yy0yNGM2MWExYWZmM2IiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiYmFsYW5jZTpyZWFkIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.Di4CZC9AD9tiVh4RFd0ChrabnBmlTQxKbEoVoJcbVdGv8L9uXS9UlcmgD9AEejdGgfIkxFG7MMdkf2v3UV8U2Fj0Qam4JZyBrG3SAdd3ymYEwYUOE8sjwwnqoL-ggJLJZxaiUxf4GjtSthbHjLw4p8ZE63GHVZGDRTR0lA544g3fbvzXaXIIA2x7-EHHQ499VCyDnK9COFj0oBgvkQmlidjG5c7TBCAoktHcdeHFgVKt-F3pOrxc5mQs0xYVWUXiWsdeGcizE6UDEZNWupY3t1BkmFcP6UfNjOgUsfSP8X2WePnos2LjhXLBP9bIuBof_GXhcS1YsWYGAxtCVqhoiQ",
   "token_type" : "bearer",
   "access_token" : "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSleUIiwia2lkIiA6ICJXWFlHdjBTRS1TdUdtMU2sU0ZmSi1vaWJ5czR0blJwb2hhTExvQzBXVFU4In0.eyJqdGkiOiJhM2M1NTA2Zi1kNGNjLTQ0Y2EtYmVhOC00NDI0ODM5NWM3MGMiLCJleHAiOjE1MjUyNzY4NTQsIm5iZiI6MCwiaWF0IjoxNTI1Mjc2NTU0LCJpc3MiOiJodHRwczovL2xvZ2luLnNpcGdhdGUuY29tL2F1dGgvcmVhbG1zL3RoaXJkLXBhcnR5IiwiYXVkIjoiMjQ3NzE0OC0wLTc0NzViOGQyLTRlMTItMTFlOC1hOTU3LWIzMWFmZDc2NzFiMiIsInN1YiI6ImY6MmU3MjQ0NDQtZTQ0YS00OWNjLThhZDgtZWYwNDEyYzQ0MDI0Ojk1NzE2MiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjI0NzcxNDgtMC03NDc1YjhkMi00ZTEyLTExZTgtYTk1Ny1iMzFhZmQ3NjcxYjIiLCJhdXRoX3RpbWUiOjE1MjUyNzYzOTksInNlc3Npb25fc3RhdGUiOiI5NDFiNDRkYy1jYmM5LTQ4ZGItYjQ3OS0xNzQxYzRjZDk1NDAiLCJhY3IiOiIxIiwiY2xpZW50X3Nlc3Npb24iOiIxZWM2M2MwZC1kOTFkLTRmZmItOTM5Yy0yNGM2MWExYWZmM2IiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiYmFsYW5jZTpyZWFkIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnt9fQ.Y3q-eFVBXc2y6dgMZkm9bSm9Y77Mfg9HzIQ80tgglo2MaioSEKi_Au5bX0DR4NBSLrpFswqaWsVy7G17R43emNhCS2Foqp5dLwDYM0ZXI0X5PFyNkANSzwf1eu16WBngkEwPqfuYNaFeOd-ZaNRrVI-hdxIgwI5jrGqhdQ1rN_pKaAp81bpxRVoBIAQWvO7iOr5GYGHtrKYnWub6uG4Egnrpju8Hl3IGK5qvhY7Xw5bmKOp_1yRihjxhgyCagMNVnUMXetK2fqpX6mCj_23CPpa0ERRbCWyNzen_T6Kgq3JHfl_5egY2Nboqm4-rF0XI8Ze1z3RUw8sOLVvLUpd5NQ"
}
```

You can extract the tokens just a explained in step 4.
