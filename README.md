# google/clasp (GAS のローカル開発環境) のコンテナ構築を自動化するスクリプト

## 事前準備

- Docker をインストールする
- Google Workspace の Apps Script 画面で設定を開き、Google Apps Script API を「オン」にする (初めて GAS で開発する時のみ)

## スクリプトの処理内容

(ホストのターミナル)

1. スクリプトを実行する  
   `$ sh init-clasp.sh (任意のプロジェクト名)`

## 開発手順 *コンテナ構築後

1. コンテナに接続する (ホストのターミナル)

    1. `$ winpty docker exec -it (任意のプロジェクト名)_app bash`

2. ソースコードを取得する (コンテナのターミナル)

    2. Google Workspace にログインする  
      `$ clasp login --no-localhost`
    3. ソースコードを GAS から取得する  
      `$ clasp clone (作成したプロジェクトのプロジェクトID)`

3. ソースコードを編集する (エディタ)

    4. ソースコードを編集する  
       *Typescript が使えるので、ファイルの拡張子は .ts にする

4. ソースコードを GAS エディタへ反映する (コンテナ内のターミナル)

    5. 編集したソースコードを GAS へ反映 (アップロード) する  
      `$ clasp push`
    6. 最新のソースコードを GAS から取得する  
      `$ clasp pull`
    7. Google Workspace からログアウトする (次回は再ログインして開発を継続すること)  
      `$ clasp logout`

## ホストのフォルダ構成

```
(プロジェクト名)/
  docker-compose.yaml
  app/
    Dockerfile
    src/
```

## コンテナ内のフォルダ構成

```
/work
  package.json
```
