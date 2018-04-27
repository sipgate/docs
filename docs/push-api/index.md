
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
