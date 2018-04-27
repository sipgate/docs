# A word about security

## HTTP vs. HTTPS

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

## Authentication

sipgate.io supports HTTP Basic Authentication. You can include your username and password within the URL (e.g. `https://username:password@example.com:8080`).
