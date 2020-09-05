# slack-send.sh and slack-ipaddr.sh

Slackにメッセージを送るシェルスクリプト

応用：「slack-ipaddr.sh」IPアドレス通知


## 1. Setting up

### 1.1 Slack上で、「Incomming WebHooks」Appを追加

この``URL``を
``~/.webhook-url``に保存

```
https://hooks.slack.com/service/......../......../......
```


## 2. Install

```bash
$ git clone https://github.com/ytani01/slack-send.git
$ cd slack-send
```

## 3. Usage

```bash
$ echo 'message' | slack-send.sh
```

## 4. 「slack-ipaddr.sh」

IPアドレスをSlackに通知します。
ラズパイなどで起動時に自動実行するようすれば、
毎回IPアドレスをスキャンする必要がなくなります。

### 自動起動の方法

「crontab-sample」を参考に crontabを設定


## A1. 参考

* [EMOJI CHEAT SHEET](https://www.webfx.com/tools/emoji-cheat-sheet/)
