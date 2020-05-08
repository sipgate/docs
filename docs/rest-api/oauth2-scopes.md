# OAuth2 scopes

Scopes are used to grant an application different levels of access to data on behalf of the end user. As an example, the scope for sending SMS (`/sessions/sms`) is `sessions:sms:write`.

!!! info "A word about security"
    It is generally a good idea to only use a minimal set of scopes to maximize security.

| Scope name                              | Description                                       |
| --------------------------------------- | ------------------------------------------------- |
| `account:read`                          | Access account details                            |
| `account:write`                         | Manage account details                            |
| `addresses:read`                        | Access addresses                                  |
| `addresses:write`                       | Manage addresses                                  |
| `authorization:oauth:clients:read`      | Access OAuth clients                              |
| `authorization:oauth:clients:write`     | Manage OAuth clients                              |
| `authorization:oauth2:clients:read`     | Access OAuth 2.0 clients                          |
| `authorization:oauth2:clients:write`    | Manage OAuth 2.0 clients                          |
| `autorecording:greeting:read`           | Access autorecording greeting                     |
| `autorecording:greeting:write`          | Manage autorecording greeting                     |
| `balance:read`                          | Access account balance                            |
| `blacklist:read`                        | Access blacklist                                  |
| `blacklist:write`                       | Manage blacklist                                  |
| `callrestrictions:read`                 | Access call restrictions                          |
| `callrestrictions:write`                | Manage call restrictions                          |
| `contacts:read`                         | Access contacts                                   |
| `contacts:write`                        | Manage contacts                                   |
| `contracts:crm:read`                    | Access your CRM contracts                         |
| `contracts:read`                        | Access contracts                                  |
| `contracts:write`                       | Manage contracts                                  |
| `devices:callerid:read`                 | Access caller ID                                  |
| `devices:callerid:write`                | Manage caller ID                                  |
| `devices:localprefix:read`              | Access automatic local area code                  |
| `devices:localprefix:write`             | Manage automatic local area code                  |
| `devices:read`                          | Access device settings                            |
| `devices:sim:read`                      | Access SIM settings                               |
| `devices:sim:write`                     | Manage SIM settings                               |
| `devices:sims:orders:write`             | Order SIM cards                                   |
| `devices:singlerowdisplay:read`         | Access hide own number settings                   |
| `devices:singlerowdisplay:write`        | Manage hide own number settings                   |
| `devices:tariffannouncement:read`       | Access rate announcement settings                 |
| `devices:tariffannouncement:write`      | Manage rate announcement settings                 |
| `devices:write`                         | Manage device settings                            |
| `events:read`                           | Access call events                                |
| `events:write`                          | Manage call events                                |
| `faxlines:numbers:read`                 | Access fax device settings (numbers)              |
| `faxlines:read`                         | Access fax device settings                        |
| `faxlines:write`                        | Manage fax device settings                        |
| `groups:devices:write`                  | Manage group device settings                      |
| `groups:faxlines:read`                  | Access group fax device settings                  |
| `groups:numbers:read`                   | Access group numbers                              |
| `groups:read`                           | Access groups                                     |
| `groups:users:read`                     | Access group members                              |
| `groups:voicemails:read`                | Access group voicemail settings                   |
| `history:read`                          | Access call history                               |
| `history:write`                         | Manage call history                               |
| `labels:read`                           | Access user labels                                |
| `labels:write`                          | Manage user labels                                |
| `log:webhooks:read`                     | Access webhooks log data                          |
| `notifications:read`                    | Access notifications                              |
| `notifications:write`                   | Manage notifications                              |
| `numbers:read`                          | Access phone numbers                              |
| `numbers:write`                         | Manage phone numbers                              |
| `openid`                                | Identify you uniquely through your sipgate login  |
| `payment:methods:read`                  | Access payment methods                            |
| `payment:methods:write`                 | Manage payment methods                            |
| `phonelines:blockanonymous:read`        | Access anonymous call settings                    |
| `phonelines:blockanonymous:write`       | Manage anonymous call settings                    |
| `phonelines:busyonbusy:read`            | Access busy on busy settings                      |
| `phonelines:busyonbusy:write`           | Manage busy on busy settings                      |
| `phonelines:devices:read`               | Access connection devices                         |
| `phonelines:devices:write`              | Manage connection devices                         |
| `phonelines:forwardings:read`           | Access call forwarding settings                   |
| `phonelines:forwardings:write`          | Manage call forwarding settings                   |
| `phonelines:numbers:read`               | Access connection numbers                         |
| `phonelines:parallelforwardings:read`   | Access parallel forwarding settings               |
| `phonelines:parallelforwardings:write`  | Manage parallel forwarding settings               |
| `phonelines:read`                       | Access connections                                |
| `phonelines:sipgateio:log:read`         | Access webhook debug log                          |
| `phonelines:sipgateio:read`             | Access webhooks                                   |
| `phonelines:sipgateio:write`            | Manage webhooks                                   |
| `phonelines:voicemails:greetings:read`  | Access connection voicemail announcement settings |
| `phonelines:voicemails:greetings:write` | Manage connection voicemail announcement settings |
| `phonelines:voicemails:read`            | Access connection voicemail settings              |
| `phonelines:voicemails:write`           | Manage connection voicemail settings              |
| `phonelines:write`                      | Manage connections                                |
| `phones:read`                           | Access provisioned phones                         |
| `phones:write`                          | Manage provisioned phones                         |
| `portings:read`                         | Access number ports                               |
| `portings:write`                        | Manage number ports                               |
| `push_device:register`                  | Manage push notifications                         |
| `rtcm:read`                             | Access active calls                               |
| `rtcm:write`                            | Manage active calls                               |
| `sessions:calls:write`                  | Initiate calls                                    |
| `sessions:fax:write`                    | Send faxes                                        |
| `sessions:sms:write`                    | Send SMS                                          |
| `sessions:write`                        | Initiate calls, send faxes, send SMS              |
| `settings:read`                         | Access global account settings                    |
| `settings:sipgateio:read`               | Access global webhooks                            |
| `settings:sipgateio:write`              | Manage global webhooks                            |
| `settings:write`                        | Manage global account settings                    |
| `sms:callerid:read`                     | Access SMS caller ID                              |
| `sms:callerid:write`                    | Manage SMS caller ID                              |
| `sms:read`                              | Access SMS device settings                        |
| `sms:write`                             | Manage SMS device settings                        |
| `trunk:read`                            | Access Trunking settings                          |
| `users:busyonbusy:write`                | Manage busy on busy settings                      |
| `users:defaultdevice:write`             | Manage default device settings                    |
| `users:read`                            | Access users                                      |
| `users:role:write`                      | Manage user roles                                 |
| `users:write`                           | Manage users                                      |
| `voicemails:read`                       | Access Voicemails                                 |
