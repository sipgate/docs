# Managing third-party clients

## Web console

You can easyly manage your API clients with the api web console located at [console.sipgate.com](https://console.sipgate.com).

## CLI or Programmatic way

In case you have to maintain your clients programmatically or by command line, you can utilize the sipgate REST API with any http client tool.

Following examples show how to create, modify or delete your API clients with the powerfull curl command line utility.

### Authentication

You only have to add the `Authorization: Bearer <access_token>` header to your requests.
There are currently two ways to obtain an `access_token`:

### Login via sipgate OAuth2

You can obtain an `access_token` by using the following curl command:

```bash
curl \
--request POST \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
--data-urlencode "client_id=<your_client_id>" \
--data-urlencode "grant_type=password" \
--data-urlencode "username=<your_sipgate_email>" \
--data-urlencode "password=<your_sipgate_password>" \
https://api.sipgate.com/login/sipgate-apps/protocol/openid-connect/token
```

The response will contain a `token` which can be used as `access_token`:
```
{
  "access_token": "<access_token>",
  "token_type": "bearer"
}
```

### Using OAuth 2.0 authentication

Read the chapter on [OAuth 2.0 Authentication](authentication#oauth2) to obtain an `access_token`.



### Creating a new client

In order to create a new client you must provide a name, a description, web origins and redirect URIs.

If you want to use the REST-API from inside a browser, you will have to add wildcards for the URIs where your user should be able to log in with sipgate to the `redirectURIs` URI and can safely ignore web origins.

If you want to create a client to use it with the sipgate Webphone, add only `[ "https://phone.sipgate.com/*"]` to `redirectURIs` and add wildcards for all domains where you want to integrate the webphone to `webOrigins`.

```bash
curl \
--request POST \
--header "Content-Type: application/json" \
--header "Authorization: Bearer <access_token>" \
--url https://api.sipgate.com/v2/authorization/oauth2/clients \
--data '{ "name": "Example name", "description": "Example description", "redirectUris": [ "https://*.example.com/*" ], "webOrigins": [ "https://*.example.com" ]}' 
```

### Retrieving all clients

This will give you a list of all clients.

```bash
curl \
--request GET \
--header "Authorization: Bearer <access_token>" \
--url https://api.sipgate.com/v2/authorization/oauth2/clients
```

### Retrieving a single client

This will give you the name, description, client secret, redirect URIs and web origins of the specified client.

```bash
curl \
--request GET \
--header "Authorization: Bearer <access_token>" \
--url https://api.sipgate.com/v2/authorization/oauth2/clients/{clientId}
```

### Updating an existing client

When updating a client, please make sure to provide a `clientId` in the path parameter.

```bash
curl \
--request PUT \
--header "Content-Type: application/json" \
--header "Authorization: Bearer <access_token>" \
--url https://api.sipgate.com/v2/authorization/oauth2/clients/{clientId} \
--data '{ "name": "Example name", "description": "Example description", "redirectUris": [ "https://*.example.com/*" ], "webOrigins": [ "https://*.example.com" ]}'
```

### Deleting a client

!!! warning
    A client, once deleted, cannot be recovered. Your users will need to authenticate themselves again with a new client.

```bash
curl \
--request DELETE \
--header "Authorization: Bearer <access_token>" \
--url https://api.sipgate.com/v2/authorization/oauth2/clients/{clientId}
```

