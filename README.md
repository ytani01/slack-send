# slack-send.sh and slack-ipaddr.sh

Slackにメッセージを送るシェルスクリプト

「slack-ipaddr.sh」をラズパイなどで、
起動時に自動実行するようにすれば、
毎回IPアドレスをスキャンする必要がなくなります。

自ホストで何らかのWebサービスを起動する場合は、
IPアドレス入りのURLを送ることもできます。


## 1. Setting up

### 1.1 Slack上で、「Incomming WebHooks」を設定

Slackの設定方法は、
時期によって変化する可能性があるので、
ネットで最新の情報を検索して下さい。

設定した``URL``を
``~/.webhook-url``に保存
```
https://hooks.slack.com/service/......../......../......
```


## 2. Install

```bash
$ git clone https://github.com/ytani01/slack-send.git
$ cd slack-send
$ ./install.sh
```


## 3. 「slack-send.sh」

任意のメッセージをSlackに送信します。

### 3.1 Usage

```
slack-send.sh [-w WEBHOOK_FILE] [-n BOTNAME] [-c CHANNEL] [-e EMOJI] [-t TITLE] [MESSAGE_FILE]
```

ex.
```
$ echo 'message' | slack-send.sh
$ slack-send.sh MESSAGE_FILE
```


## 4. 「slack-ipaddr.sh」

IPアドレスをSlackに通知します。

ラズパイなどで起動時に自動実行するようにすれば、
毎回IPアドレスをスキャンする必要がなくなります。

### 4.1 Usage

```
slack-ipaddr.sh [-hsv] [-w WEBHOOK_URL_FILE] [-n BOT_NAME] [-c CHANNEL] [-e EMODJI] [-t TITLE] [-p PORT] [-u URL_PATH]

  -h	HTTP URL flag
  -s	HTTPS URL flag
  -p	port number of URL
  -u	URL path
  -v	verbose
```

### 4.2 自動起動の方法

「crontab-sample」を参考に crontabを設定



## A1. 参考

* [EMOJI CHEAT SHEET](https://www.webfx.com/tools/emoji-cheat-sheet/)
