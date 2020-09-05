# slack-send.sh and slack-ipaddr.sh

Slackにメッセージを送るシェルスクリプト

応用：「slack-ipaddr.sh」IPアドレス通知


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
$ ./setup.sh
```


## 3. 「slack-send.sh」

### 3.1 Usage

```bash
$ echo 'message' | slack-send.sh
```


## 4. 「slack-ipaddr.sh」

IPアドレスをSlackに通知します。

ラズパイなどで起動時に自動実行するようにすれば、
毎回IPアドレスをスキャンする必要がなくなります。

### 4.1 Usage

```bash
$ slack-ipaddr.sh
```

### 4.2 自動起動の方法

「crontab-sample」を参考に crontabを設定



## A1. 参考

* [EMOJI CHEAT SHEET](https://www.webfx.com/tools/emoji-cheat-sheet/)
