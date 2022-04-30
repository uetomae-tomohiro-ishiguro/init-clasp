# google/clasp (GAS のローカル開発環境) のコンテナ構築を自動化するスクリプト

## 事前準備

- Docker をインストール

## スクリプトの処理内容

(ホストのターミナル)

1. スクリプトを実行する
   `$ sh init-clasp.sh (任意のプロジェクト名)`

## 開発手順 *コンテナ構築後

1. (Web ブラウザ)

    1. Google Workspace (旧 GSuite) にログインする
    2. Google Workspace の Apps Script 画面で設定を開き、Google Apps Script API を「オン」にする
    3. プロジェクトを作成する

2. (コンテナのターミナル)

    4. ログインする
      `$ clasp login --no-localhost`
    5. コードを GAS から取得する
      `$ clasp clone (上記3. で作成したプロジェクトのプロジェクトID)`

3. (エディタ)

    6. ソースコードを編集する *Typescript が使えるので、ファイルの拡張子は .ts にする

4. (コンテナ内のターミナル)

    7. コードを GAS へアップロードする
      `$ clasp push`
    8. コードを GAS から取得する
      `$ clasp pull`
    9. ログアウトする (次回は再ログインして開発を継続すること)
      `$ clasp logout`

## ホストのフォルダ構成

```
(プロジェクト名)/
  docker-compose.yaml
  app/
    Dockerfile
    package.json
    package-lock.json
    src/
```

## コンテナ内のフォルダ構成

```
/work
  package.json
  package-lock.json
  node_modules/
```
