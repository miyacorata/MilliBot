# MilliBot
お誕生日のツイートをするやつ

## .env
以下の情報が必要
* Mastodonインスタンスのドメイン
* アプリのキーとシークレット
* MySQL(MariaDB)データベースの情報

`.env.example`を参考に`.env`を書く

## DB
DBの構造は最小限以下が必要

|カラム名|データ型|内容|
|:--:|:--:|:--:|
|name|text|名前(漢字)|
|subname|text|ニックネーム等(ロコとか)|
|type|enum|ゲーム内の属性|
|age|int|年齢|

## Usage
cronとかでエイッ
