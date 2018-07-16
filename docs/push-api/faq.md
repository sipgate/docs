# FAQ

## What happens when a call is transferred?

The transferred call is a new call. Scenario: Jennifer calls Doc Brown and Doc Brown transfers the call to Marty and Marty picks up. 
 Here's what sipgate.io sends to your server:

1. `newCall (user: Doc, callId: 12111955)`
2. `answer (user: Doc, callId: 12111955)`
  * `[Doc dials *3 <Marty's extension>]`
3. `newCall (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
4. `answer (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
5. `hangup (user: Doc, callId: 12111955)`

As you can see, the ```callId``` changes with the transfer.

This is what sipgate.io sends, in case Marty does not pick up:

1. `newCall (user: Doc, callId: 12111955)`
2. `answer (user: Doc, callId: 12111955)`
  * `[Doc dials *3 <Marty's extension>]`
3. `newCall (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
4. `hangup (user: Marty, callId: 21102015)`

## How is forwarding signaled?

The forwarded call is handled as a new call. Let's assume the previous scenario: Jennifer calls Doc Brown but his line is busy so the call is forwarded to Marty who in turn picks up the call.  
Here are the pushes sipgate.io will send to your server:

1. `newCall (user: Doc, callId: 12111955)`
2. `hangup (cause: forwarded, callId: 12111955)`
3. `newCall (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
4. `answer (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
5. `hangup (user: Marty, callId: 21102015)`

## I get a lot of event during forwards and transfers, do I have to pay for all of them?

The answer is: It depends.  
If you transfer or forward a call within the same sipgate account then the answer is no. But if you forward or transfer a call to a different sipgate account or an external number then those pushes are being billed to your account.

## I want to implement more complex interaction scenarios and can't answer to a push request directly. Can I control a call asynchronously?

In every push request the `callId` parameter is included to identify the current call. Use the `callId` to manipulate the call at any time with our [RTCM-API](/rest-api/rtcm).

## What about Emergency calls?

sipgate.io does not process emergency calls. Emergency calls are immediately put through to emergency services.
