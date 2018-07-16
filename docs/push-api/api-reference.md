# API References

## The POST request

When enabled, sipgate.io sends POST requests with an `application/x-www-form-urlencoded` payload for each of call involving your sipgate account. Depending on the type of request it contains the following parameters:

### New call

Parameter    | Description
------------ | -----------
event        | "newCall"
from         | The calling number (e.g. `"492111234567"` or `"anonymous"`)
to           | The called number (e.g. `"4915791234567"`)
direction    | The direction of the call (either `"in"` or `"out"`)
callId       | A unique alphanumeric identifier to match events to specific calls.
user[]       | The sipgate user(s) involved. It is the name of the calling user when direction is `"out"`, or of the users receiving the call when direction is `"in"`. Group calls may be received by multiple users. In that case a `"user[]"` parameter is set for each of these users. It is always `"user[]"` (not `"user"`), even if only one user is involved.
userId[]     | The IDs of sipgate user(s) involved (e.g. `w0`).
fullUserId[] | The full IDs of sipgate user(s) involved (e.g. `1234567w0`).

You can simulate this POST request and test your server with a cURL command:

```bash
curl \
  -X POST \
  --data "event=newCall&from=492111234567&to=4915791234567&direction=in&callId=123456&user[]=Alice&user[]=Bob&userId[]=w0&userId[]=w1&fullUserId[]=1234567w0&fullUserId[]=1234567w1" \
  http://localhost:3000
```

Optional Parameter | Description
-------------------|------------
diversion          | If a call was diverted before it reached sipgate.io this contains the originally dialed number. 

### Follow up events

In your response to the new call event POST request, you can [subscribe to receive following events of the concerned call](#following-events). 

## The XML response

After sending the POST request sipgate.io will accept an XML response to determine what to do. Make sure to set ```application/xml``` in the ```Content-Type``` header of your response.

sipgate.io currently supports the following responses for incoming and outgoing calls:

Action            | Description
----------------- | -----------
[Dial](#dial)     | Send call to voicemail or external number
[Play](#play)     | Play a sound file
[Gather](#gather) | Collects digits that a caller enters with the telephone keypad.
[Reject](#reject) | Reject call or pretend to be busy
[Hangup](#hangup) | Hang up the call

### Actions


#### Dial


Redirect the call and alter your caller id ([call charges apply](https://www.simquadrat.de/tarife/mobile)). Calls with ```direction=in``` can be redirected to up to 5 targets.

Attribute | Possible values                                              | Default value
--------- | ------------------------------------------------------------ | -------------
callerId  | Number in [E.164](http://en.wikipedia.org/wiki/E.164) format | Account settings
anonymous | true, false                                                  | Account / phone settings

Possible targets for the dial command:

Target    | Description
--------- | -----------
Number    | Send call to an external number (has to be in [E.164](http://en.wikipedia.org/wiki/E.164) format)
Voicemail | Send call to [voicemail](https://www.simquadrat.de/feature-store/voicemail) (feature has to be booked)


**Example 1: Redirect call**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Dial>
		<Number>4915799912345</Number>
	</Dial>
</Response>
```

**Example 2: Send call to voicemail**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Dial>
		<Voicemail />
	</Dial>
</Response>
```

**Example 3: Suppress phone number**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Dial anonymous="true">
		<Number>4915799912345</Number>
	</Dial>
</Response>
```

**Example 4: Set custom caller id for outgoing call**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Dial callerId="492111234567">
		<!-- Originally dialed number, extracted from POST request -->
		<Number>4915799912345</Number>
	</Dial>
</Response>
```

**Example 5: Redirect incoming call to multiple destinations**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Dial>
		<Number>4915799912345</Number>
		<Number>492111234567</Number>
	</Dial>
</Response>
```

When the call is answered, the resulting answer-event reports the answering destination in a field called ```answeringNumber```.

#### Play

Play a given sound file. Afterwards the call is delivered as it would have been without playing the sound file.

Target    | Description
--------- | -----------
Url       | Play a sound file from a given URL


**Example 1: Play a sound file**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Play>
		<Url>http://example.com/example.wav</Url>
	</Play>
</Response>
```

**Please note:** Currently the sound file needs to be a mono 16bit PCM WAV file with a sampling rate of 8kHz. You can use conversion tools like the open source audio editor [Audacity](http://audacity.sourceforge.net/) to convert any sound file to the correct format.

Linux users might want to use ```mpg123``` to convert the file:
```bash
mpg123 --rate 8000 --mono -w output.wav input.mp3
```

#### Gather

Gather collects digits that a caller enters with the telephone keypad. The onData attribute is mandatory and takes an absolute URL as a value.

Attribute | Possible values | Default value
--------- | --------------- | -------------
type      | dtmf | dtmf
onData    | absolute URL | -
maxDigits | integer >= 1 | 1
timeout (ms) | integer >= 1 | 2000

**Nesting Rules**

The following verbs can be nested within ```<Gather>```:

* [Play](#play) The timeout starts after the sound file has finished playing. After the first digit is received the audio will stop playing.

**Example 1: DTMF with sound file and additional parameters**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Gather onData="http://localhost:3000/dtmf" maxDigits="3" timeout="10000">
		<Play>
			<Url>https://example.com/example.wav</Url>
		</Play>
	</Gather>
</Response>
```

#### Reject

Pretend to be busy or block unwanted calls.

Attribute | Possible values | Default value
--------- | --------------- | -------------
reason    | rejected, busy  | rejected


**Example 1: Reject call**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Reject />
</Response>
```

**Example 2: Reject call signaling busy**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Reject reason="busy" />
</Response>
```

#### Hangup

Hang up calls

**Example: Hang up call**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
	<Hangup />
</Response>
```

### Following events 

Additional to actions, the response can specify urls which shall be called by sipgate.io on certain call-events. Specify these urls via xml-attributes in the response-tag.

Url                   | Description
--------------------- | -----------
[onAnswer](#onanswer) | Receives a POST-request as soon as someone answers the call. The response to that request is discarded.
[onHangup](#onhangup) | Receives a POST-request as soon as the call ends for whatever reason. The response to that request is discarded.


#### onAnswer

If you set the `onAnswer` attribute sipgate.io will push an answer-event, when
a call is answered by the other party.

**Example: Request notification for call being answered**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response onAnswer="http://localhost:3000/answer" />
```


Parameter       | Description
--------------- | -----------
event           | "answer"
callId          | Same as in newCall-event for a specific call
user            | Name of the user who answered this call. Only incoming calls can have this parameter
userId          | The ID of sipgate user(s) involved (e.g. `w0`).
fullUserId      | The full ID of sipgate user(s) involved (e.g. `1234567w0`).
from            | The calling number (e.g. `"492111234567"` or `"anonymous"`)
to              | The called number (e.g. `"4915791234567"`)
direction       | The direction of the call (either `"in"` or `"out"`)
answeringNumber | The number of the answering destination. Useful when redirecting to multiple destinations

You can simulate this POST request and test your server with a cURL command:

```bash
curl \
  -X POST \
  --data "event=answer&callId=123456&user=John+Doe&userId=w0&fullUserId=1234567w0&from=492111234567&to=4915791234567&direction=in&answeringNumber=21199999999" \
  http://localhost:3000
```

Optional Parameter | Description
-------------------|------------
diversion          | If a call was diverted before it reached sipgate.io this contains the originally dialed number.


#### onHangup

If you set the `onHangup` attribute sipgate.io will push a hangup-event
when the call ends.

**Example: Request notification for call hangup**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response onHangup="http://localhost:3000/hangup" />
```

Parameter       | Description
--------------- | -----------
event           | "hangup"
cause           | The cause for the hangup event (see [table](#hangup-causes) below)
callId          | Same as in newCall-event for a specific call
from            | The calling number (e.g. `"492111234567"` or `"anonymous"`)
to              | The called number (e.g. `"4915791234567"`)
direction       | The direction of the call (either `"in"` or `"out"`)
answeringNumber | The number of the answering destination. Useful when redirecting to multiple destinations

You can simulate this POST request and test your server with a cURL command:

```bash
curl \
  -X POST \
  --data "event=hangup&cause=normalClearing&callId=123456&from=492111234567&to=4915791234567&direction=in&answeringNumber=4921199999999" \
  http://localhost:3000
```

Optional Parameter | Description
-------------------|------------
diversion          | If a call was diverted before it reached sipgate.io this contains the originally dialed number.

##### Hangup causes

Hangups can occur due to these causes:

Cause           | Description
--------------- | -----------
normalClearing  | One of the participants hung up after the call was established
busy            | The called party was busy
cancel          | The caller hung up before the called party picked up
noAnswer        | The called party rejected the call (e.g. through a DND setting)
congestion      | The called party could not be reached
notFound        | The called number does not exist or called party is offline
forwarded       | The call was forwarded to a different party


#### onData

If you ["gather"](#gather) users' dtmf reactions, this result is pushed as an event to the url specified in the `onData` attribute with the following parameters: 

Parameter | Description
--------- | -----------
event     | "dtmf"
dtmf      | Digit(s) the user has entered. If no input is received, the value of dtmf will be empty.
callId    | Same as in newCall-event for a specific call

You can simulate this POST request and test your server with a cURL command:

```bash
curl \
  -X POST \
  --data "event=dtmf&dtmf=1&callId=123456" \
  http://localhost:3000
```

## Advanced scenarios

In addition to answering push requests synchronously you can interact with calls in real time through our [RTCM-API](/rest-api/rtcm). Use the `callId` parameter that is included in every push request.

