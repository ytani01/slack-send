# slack-send

Slackにメッセージを送るシェルスクリプト


## 1. Setting up

### 1.1 Slack上で、「Incomming WebHooks」Appを追加

この``URL``を
``~/.webhook-url``に保存


## 2. Install

```bash
$ git clone https://github.com/ytani01/slack-send.git
$ cd slack-send
```

## 3. Usage

```bash
$ echo 'message' | slack-send.sh
```