# OAuth2 scopes

Scopes are used to grant an application different levels of access to data on behalf of the end user. As an example, the scope for sending SMS (`/sessions/sms`) is `sessions:sms:write`.

!!! info "A word about security"
    It is generally a good idea to only use a minimal set of scopes to maximize security.

| Scope name | Description |
|----------- |-------------|
| `all` | Full access |
| `contacts:read` | Read contact information |
| `devices:localprefix:read` | Read your device settings for localprefix |
| `devices:sim:read` | Read your sim device settings |
| `devices:tariffannouncement:write` | Modify your device settings for tariff announcement |
| `phonelines:blockanonymous:read` | Read your block anonymous settings |
| `phonelines:blockanonymous:write` | Change your block anonymous settings |
| `phonelines:devices:write` | Modify your phone line devices |
| `phonelines:forwardings:read` | Read your phone line forwardings |
| `phonelines:read` | Read your phone line settings |
| `phonelines:sipgateio:read` | Read your phone line sipgate.io settings |
| `phonelines:sipgateio:write` | Modify your phone line sipgate.io settings |
| `phonelines:voicemails:greetings:write` | Modify your phone line voicemail greetings |
| `phonelines:voicemails:read` | Read your phone line voicemails |
| `phonelines:write` | Modify our phone line settings |
| `portings:read` | Read your portings |
| `push_device:register` | Register device for push notifications |
| `sessions:sms:write` | Send SMS |
| `settings:sipgateio:write` | Modify your sipgate.io settings |
| `sms:callerid:write` | Modify your short message services |
| `sms:write` | Modify your short message services |
| `users:read` | Read user information |
| `account:read` | Read account information |
| `account:write` | Modify your account |
| `addresses:read` | Read address information |
| `addresses:write` | Modify your addresses |
| `authorization:oauth:clients:read` | Read your oauth clients |
| `authorization:oauth:clients:write` | Modify your oauth clients |                                                                                                                                                                                                            
| `balance:read` | Read balance information |                                                                                                                                                                                                                                  
| `contacts:write` | Write contact information |                                                                                                                                                                                                                               
| `devices:callerid:read` | Read your device settings for callerId |                                                                                                                                                                                                           
| `devices:callerid:write` | Modify your device settings for callerId |                                                                                                                                                                                                        
| `devices:localprefix:write` | Modify your device settings for localprefix |                                                                                                                                                                                                  
| `devices:read` | Read your devices |                                                                                                                                                                                                                                         
| `devices:sim:write` | Modify your sim device settings |                                                                                                                                                                                                                      
| `devices:sims:orders:write` | Order new SIM cards |                                                                                                                                                                                                                          
| `devices:singlerowdisplay:read` | Read your device settings for single row display |                                                                                                                                                                                         
| `devices:singlerowdisplay:write` | Modify your device settings for single row display |                                                                                                                                                                                      
| `devices:tariffannouncement:read` | Read your device settings for tariff announcement |                                                                                                                                                                                      
| `devices:write` | Modify your devices |                                                                                                                                                                                                                                      
| `faxlines:numbers:read` | Read your fax line numbers |                                                                                                                                                                                                                       
| `faxlines:read` | Read your fax line settings |                                                                                                                                                                                                                              
| `faxlines:write` | Modify your fax line settings |                                                                                                                                                                                                                           
| `groups:devices:write` | Modify your group devices |                                                                                                                                                                                                                         
| `groups:faxlines:read` | Read your group faxlines |                                                                                                                                                                                                                          
| `groups:numbers:read` | Read numbers routed to your groups |                                                                                                                                                                                                                 
| `groups:read` | Read your groups |                                                                                                                                                                                                                                           
| `groups:users:read` | Read your group members |                                                                                                                                                                                                                              
| `groups:voicemails:read` | Read your group voicemails |                                                                                                                                                                                                                      
| `history:read` | Read your history |                                                                                                                                                                                                                                         
| `history:write` | Modify your history |                                                                                                                                                                                                                                      
| `notifications:read` | Read notifications |                                                                                                                                                                                                                                  
| `notifications:write` | Modify notifications |                                                                                                                                                                                                                               
| `numbers:read` | Read your numbers |                                                                                                                                                                                                                                         
| `numbers:write` | Route numbers to phone lines |                                                                                                                                                                                                                             
| `openid` | Identify you uniquely through your sipgate login |                                                                                                                                                                                                                
| `phonelines:busyonbusy:read` | Read your busy on busy settings |                                                                                                                                                                                                             
| `phonelines:busyonbusy:write` | Change your busy on busy settings |                                                                                                                                                                                                          
| `phonelines:devices:read` | Read your phone line devices |                                                                                                                                                                                                                   
| `phonelines:forwardings:write` | Modify your phone line forwardings |                                                                                                                                                                                                        
| `phonelines:numbers:read` | Read your phone line numbers |
| `phonelines:parallelforwardings:read` | Read your parallel forwardings |
| `phonelines:parallelforwardings:write` | Modify your parallel forwardings |
| `phonelines:sipgateio:log:read` | Read your phone line sipgate.io log |
| `phonelines:voicemails:greetings:read` | Read your phone line voicemail greetings |
| `phonelines:voicemails:write` | Modify your phone line voicemails |
| `portings:write` | Modify your portings |
| `sessions:calls:write` | Initiate phone calls |
| `sessions:fax:write` |Send Fax |
| `sessions:write` | Initiate sessions |
| `settings:read` | Read your settings |
| `settings:sipgateio:read` | Read your sipgate.io settings |
| `settings:write` | Modify your settings |
| `sms:callerid:read` | Read your short message services |
| `sms:read` | Read your short message services |
| `users:defaultdevice:write` | Modify your default device settings |
