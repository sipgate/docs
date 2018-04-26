# Push API

## Set up webhooks in your sipgate account

### Create a sipgate account

To begin developing applications using webhooks you first need to create a sigpgate account. There are different types of accounts: basic, simquadrat and team. All are slightly different but offer webhooks functionality. For the following examples we choose [sipgate basic](https://www.sipgatebasic.co.uk) because it's free (as in beer).

### Book sipgate.io

We will now show you how to book sipgate.io using the Feature Store.

![Book sipgate.io](../img/configure-sipgate-io-step1.png)

Log into your shiny, new sipgate account and go to the Feature Store. You can find a link in the navigation.

![Within the Feature Store click on the sipgate.io feature. It should look like this.](../img/configure-sipgate-io-step2.png)

Within the Feature Store click on the sipgate.io feature. It should look like this.

![Click on the orange button to book the free feature and follow the confirmation process.](../img/configure-sipgate-io-step3.png)

Click on the orange button to book the free feature and follow the confirmation process.

### Enable webhooks

We will now show you how to configure your URLs.

![Navigate to the sipgate.io category and click on "Incoming calls" or "Outgoing calls".](../img/configure-sipgate-io-step4.png)

Navigate to the sipgate.io category and click on "Incoming calls" or "Outgoing calls"

![Enter your URL and hit "Save".](../img/configure-sipgate-io-step5.png)

Enter your URL and hit "Save".


## API Reference & Examples

https://github.com/sipgate/sipgate.io

## Troubleshooting

### Enable debug log

You can enable logging for debugging purposes from your dashboard. You will find each request and the corresponding response in the logging table.

![Click on "Activate debug log", read and confirm the security warning.](../img/debug-sipgate-io-step1.png)

Click on "Activate debug log", read and confirm the security warning.

![To view the logged requests, click on the icon within the "Activate debug log" row.](../img/debug-sipgate-io-step2.png)

To view the logged requests, click on the icon within the "Activate debug log" row.


![Your request should be logged and look like this.](../img/debug-sipgate-io-step3.png)

Your request should be logged and look like this.

### Inspect incoming network traffic

You can use `ngrep` to inspect incoming requests 
```shell
sudo ngrep -dany -Wbyline port 3000
```

The output should look like this
```
###
T 10.42.42.42:42528 -> 10.42.42.23:3000 [AP]
POST / HTTP/1.1.
Accept: application/xml, text/plain, text/html.
Accept-Charset: utf-8.
User-Agent: sipgate.io.
X-SIPGATE-JOBS: http://www.sipgate.de/jobs.
Content-Length: 84.
Content-Type: application/x-www-form-urlencoded; charset=UTF-8.
Accept-Encoding: gzip,deflate.
Host: gwen.fuglu.net:3000.
Via: 1.1 localhost (squid/3.1.20).
X-Forwarded-For: 217.10.77.113.
Cache-Control: max-age=259200.
Connection: keep-alive.
.

##
T 10.42.42.42:42528 -> 10.42.42.23:3000 [AP]
event=newCall&direction=in&from=anonymous&to=445603000514&callId=4932215337270853042
##
T 10.42.42.23:3000 -> 10.42.42.42:42528 [AP]
HTTP/1.1 200 OK.
X-Powered-By: Express.
Content-Type: application/xml; charset=utf-8.
Content-Length: 46.
Date: Tue, 23 May 2017 11:27:11 GMT.
Connection: keep-alive.
.
<Response><Dial><Voicemail/></Dial></Response>
#
``` 

## A word about security

### HTTP vs. HTTPS

We strongly encourage you to use a HTTPS server. Although we support plain HTTP connections we do not recommend pushing sensitive call details over unencrypted connections. By default sipgate.io does not accept [self-signed certificates](http://stackoverflow.com/a/10176685). If you use simquadrat or sipgate basic, you can allow self-signed certs in your dashboard. In sipgate team you cannot make an exception.

Furthermore, you can add your public certificate to protect the connection against man-in-the-middle attacks. Your certificate is validated by our server.

In order to work your certificate has to be in the following format
```
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAJC1HiIAZAiIMA0GCSqGSIb3Df
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVx
aWRnaXRzIFB0eSBMdGQwHhcNMTExMjMxMDg1OTQ0WhcNMT
A .... MANY LINES LIKE THAT ....
JjyzfN746vaInA1KxYEeI1Rx5KXY8zIdj6a7hhphpj2E04
C3Fayua4DRHyZOLmlvQ6tIChY0ClXXuefbmVSDeUHwc8Yu
B7xxt8BVc69rLeHV15A0qyx77CLSj3tCx2IUXVqRs5mlSb
vA==
-----END CERTIFICATE-----
```

### Authentication

sipgate.io supports HTTP Basic Authentication. You can include your username and password within the URL (e.g. `https://username:password@example.com:8080`).


## FAQ

### What happens when a call is transferred?

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

### How is forwarding signaled?

The forwarded call is handled as a new call. Let's assume the previous scenario: Jennifer calls Doc Brown but his line is busy so the call is forwarded to Marty who in turn picks up the call.  
Here are the pushes sipgate.io will send to your server:

1. `newCall (user: Doc, callId: 12111955)`
2. `hangup (cause: forwarded, callId: 12111955)`
3. `newCall (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
4. `answer (user: Marty, callId: 21102015, diversion: <Doc's number> from: <Jennifer's number>)`
5. `hangup (user: Marty, callId: 21102015)`

### I get a lot of event during forwards and transfers, do I have to pay for all of them?

The answer is: It depends.  
If you transfer or forward a call within the same sipgate account then the answer is no. But if you forward or transfer a call to a different sipgate account or an external number then those pushes are being billed to your account.


## Setting up ngrok for local development

### Make your project accessible from the internet

The sipgate.io API cannot reach your project if the computer running it is behind a firewall. An easy way to circumvent this impediment is a tunnel service. [Ngrok](https://ngrok.com) is easy to use and offers a free service which is sufficient for our needs. Download and run ngrok now, to make your project available from the internet.

Download ngrok for linux (amd64)

```shell
wget https://dl.ngrok.com/ngrok_2.0.17_linux_amd64.zip -O ngrok.zip
```

Download ngrok for osx

```shell
wget https://dl.ngrok.com/ngrok_2.0.17_darwin_amd64.zip -O ngrok.zip
```
Run ngrok

```shell
unzip ngrok.zip
./ngrok http 9000
```

![Ngrok running](./img/ngrok-running.png)

Ngrok builds the tunnel and shows the newly generated tunnel url. This url changes with every restart of ngrok. In this example our project is reachable on https://12345678.ngrok.io/.
