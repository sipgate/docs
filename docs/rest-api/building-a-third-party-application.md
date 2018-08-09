# Building a third-party application

This tutorial walks you through the basic steps of creating a Node.js application that communicates with our REST-API. You can find the [complete source code to this article on github](https://github.com/sipgate/rest-api-examples/tree/master/webapp-nodejs).

## Set up a basic Node.js project

We want to create a simple proof-of-concept Express app without a persistence layer. To get started create a new folder, run npm init and follow the instructions.
To follow the tutorial you will need to install the following dependencies. These will also shorten your code and make it easier to read.

```bash
npm init
npm install --save express express-session request request-promise-native sipgate-rest-api-client-v2
```

Feel free to substitute dependencies to your needs.

## Create a third party client

Refer to our article [managing third-party clients](./managing-third-party-clients.md) to learn how to create a new client. Save the `clientId` and the `clientSecret` as you will need them to build your application.

## Choose your scopes

Scopes are used to grant an application different levels of access to data on behalf of the end user. As an example, the scope for sending SMS (`/sessions/sms`) is `sessions:sms:write`.

Refer to our [complete list of scopes](./oauth2-scopes.md) to find the appropriate ones for your application.

## Obtain a sipgate access token for a user

After registering a client you can obtain API an `access_token` for sipgate users and access the API following the OAuth2 Authorization Code Flow in three steps.

### 1. Redirect the user to the authorization server

Redirect a user to our authorization server to acquire an access grant code. The user will be prompted to accept the OAuth scopes requested by your application.

```js
const queryString = require('querystring');
const apiAuthUrl = 'https://login.sipgate.com/auth/realms/third-party/protocol/openid-connect/auth'
  + queryString.stringify({
      client_id: 'YOUR_API_CLIENT_ID',
      redirect_uri: 'http://localhost:3000/authorize',
      scope: 'balance:read',
      response_type: 'code',
  });
res.redirect(apiAuthUrl);
```

### 2. Provide a redirect endpoint to retrieve the authorization callback

After authorization we redirect users back to the URL you provided (here `http://localhost:3000/authorize`), including the access grant code as a query parameter.
In this example the token is kept in memory using the [express-session middleware](https://github.com/expressjs/session) and the user is redirected to `/`. The token will be kept in memory until process terminates. In a production environment you would most likely want to persist the token in some way.

```js
const authorizationCode = req.query.code;
const apiTokenUrl = "https://login.sipgate.com/auth/realms/third-party/protocol/openid-connect/token";

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
```

### 3. Use the access token to communicate with our API

Now that you have obtained the token you can use the [sipgate REST API client](https://www.npmjs.com/package/sipgate-rest-api-client-v2) to communicate with our API on behalf of the authorized user. Here we use it to display the current account balance.

```js
const createApiClient = require('sipgate-rest-api-client-v2').default;
const accessToken = req.session['accessToken'];
const apiClient = createApiClient(apiUrl, accessToken);
apiClient.getBalance()
    .then(function (response) {
      if (!(response['amount'] && response['currency'])) {
        throw 'Malformed response';
      }

      const balanceFormatted = (parseInt(response['amount'], 10) / 10000).toFixed(2);
      res.send(`Your sipgate account balance is ${balanceFormatted} ${response['currency']}.`);
    })
    .catch(function(reason) {
      if (reason === 'Unauthorized') {
        res.redirect(authPath);
        return;
      }
      res.send('Sorry, something went wrong. Please try again.');
    });
```

## That's it!
   
Check out the [API documentation](https://api.sipgate.com/v2/doc) to see all possible ways to interact with our service.

