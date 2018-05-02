# Real Time Call Manipulation

## What is Real Time Call Manipulation?

The Real Time Call Manipulation API enables you to modify currently running calls. Every call has a `callId` and you can use this ID to modify the state of that call.

## What is the callId?

The `callId` will either be pushed to you by using a [Webhook](../push-api/api-reference/#the-post-request)  (see `callId`) or you can obtain it by initiating a call using the [/sessions/calls][swagger] endpoint (see `sessionId`).

## Authentication

You only have to add the `Authorization: Bearer <access_token>` header to your requests.
There are currently two ways to obtain an `access_token`:

### Using sipgate authentication
 
You can obtain an `access_token` by using curl:

```shell
 curl \
--request POST \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
--data-urlencode "client_id=sipgate-app-web" \
--data-urlencode "grant_type=password" \
--data-urlencode "username=<your_sipgate_email>" \
--data-urlencode "password=<your_sipgate_username>" \
https://api.sipgate.com/login/sipgate-apps/protocol/openid-connect/token
```

The response will contain a `token` which can be used as `access_token`:
```
{"token":"eyJ0eXAiOiJKV1...."}
```

## Using OAuth 2.0 authentication

Read the chapter on [OAuth 2.0 Authentication](authentication#oauth2) to obtain an `access_token`.



### How to get all running calls

You only need your `access_token` to call the [/calls][swagger] endpoint.

```bash
curl \
--verbose \
--request GET \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls
```


### How to put a call on hold

You can put all call participants on hold or retrieve them by using the [/calls/{callId}/hold][swagger] endpoint. All you need is the `callId` and your `access_token`:

```bash
 Hold
curl \
--verbose \
--request PUT \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/hold \
--data '{ "value": true }'
 Retrieve
curl \
--verbose \
--request PUT \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/hold \
--data '{ "value": false }'
```

### How to mute/unmute a call

You can use the [/calls/{callId}/muted][swagger] endpoint to mute or unmute your microphone. All you need is the `callId` and your `access_token`:

```bash
 Mute
curl \
--verbose \
--request PUT \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/muted \
--data '{ "value": true }'

 Unmute
curl \
--verbose \
--request PUT \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/muted \
--data '{ "value": false }'
```

### How to transfer a call

You can use the [/calls/{callId}/transfer][swagger] endpoint to transfer your call to another party. You can choose between attended transfer and blind transfer. All you need is the `callId` and your `access_token`:

```bash
 Attended transfer
curl \
--verbose \
--request POST \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/transfer \
--data '{ "attended": true, "phoneNumber": "+4915799912345" }'

 Blind transfer
curl \
--verbose \
--request POST \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/transfer \
--data '{ "attended": false, "phoneNumber": "+4915799912345" }'
```

### How to record a call

Use the [/calls/{callId}/recording][swagger] endpoint to record a running call. 
Pass `"value": true` to start the recording and `"value": false` to stop it.
You can enable/disable the recording announcement by passing the `announcement` flag.

```bash
 Start recording with announcement
curl \
--verbose \
--request PUT \
--header 'Authorization: Bearer <access_token>' \
--header 'Content-Type: application/json' \
--url https://api.sipgate.com/v2/calls/<callId>/recording \
--data '{ "value": true, "announcement": true }'

 Stop recording without announcement
curl \
--verbose \
--request PUT \
--header 'Authorization: Bearer <access_token>' \
--header 'Content-Type: application/json' \
--url https://api.sipgate.com/v2/calls/<callId>/recording \
--data '{ "value": false, "announcement": false }'
```

To retrieve the recorded file you can use the [/v2/{userId}/history][swagger] endpoint (see `recordingUrl`).

```bash
curl \
--verbose \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/<userId>/history?types=CALL
```

### How to send DTMF (Dual-tone multi-frequency) sequences

Use the [/calls/{callId}/dtmf][swagger] endpoint to send a DTMF sequence to a running call:

```bash
curl \
--verbose \
--request POST \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/dtmf \
--data '{ "sequence": "*12345#" }'
```

### How to play an audio file

You can inject any WAV file into a running call by using the [/calls/{callId}/announcements][swagger] endpoint. All you need is the `callId`, a WAV file and your `access_token`:

```bash
curl \
--verbose \
--request POST \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>/announcements \
--data '{ "url": "https://static.sipgate.com/examples/wav/example.wav" }'
```

**Please note:** Currently the sound file needs to be a mono 16bit PCM WAV file with a sampling rate of 8kHz. You can use conversion tools like the open source audio editor [Audacity](http://www.audacityteam.org/) to convert any sound file to the correct format.

Alternatively you could convert the file using `mpg123` on the command line:

```bash
mpg123 --rate 8000 --mono -w output.wav input.mp3
```

### How to hang up a call

Use the [DELETE /calls/{callId}][swagger] endpoint to terminate a running call. All you need is the `callId` and your `access_token`:

```bash
curl \
--verbose \
--request DELETE \
--header "Authorization: Bearer <access_token>" \
--header "Content-Type: application/json" \
--url https://api.sipgate.com/v2/calls/<callId>
```

[swagger]: https://api.sipgate.com/v2/doc
