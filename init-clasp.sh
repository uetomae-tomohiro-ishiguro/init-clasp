#!/bin/bash

## # google/clasp (GAS のローカル開発環境) のコンテナ構築を自動化するスクリプト
##
## ## 事前準備
## - Docker をインストール
##
## ## スクリプトの処理内容
## (ホストのターミナル)
## 1. スクリプトを実行する
##    $ sh init-clasp.sh (任意のプロジェクト名)
##    1) 引数を使ってプロジェクトのフォルダをつくる
##    2) docker-compose.yaml を生成する
##    3) app フォルダをつくる
##    4) app フォルダにDockerfile を生成する
##    5) コンテナを起動する
##
## ## 開発手順 *コンテナ構築後
## (Web ブラウザ)
## 1. Google Workspace (旧 GSuite) にログインする
## 2. Google Workspace の Apps Script 画面で設定を開き、Google Apps Script API を「オン」にする
## 3. プロジェクトを作成する
## (コンテナのターミナル)
## 4. ログインする
##   $ clasp login --no-localhost
## 5. コードを GAS から取得する
##   $ clasp clone (上記3. で作成したプロジェクトのプロジェクトID)
## (エディタ)
## 6. ソースコードを編集する *Typescript が使えるので、ファイルの拡張子は .ts にする
## (コンテナ内のターミナル)
## 7. コードを GAS へアップロードする
##   $ clasp push
## 8. コードを GAS から取得する
##   $ clasp pull
## 9. ログアウトする (次回は再ログインして開発を継続すること)
##   $ clasp logout
##
## ## ホストのフォルダ構成
## (プロジェクト名)/
##   docker-compose.yaml
##   app/
##     Dockerfile
##     package.json
##     package-lock.json
##     src/
##
## ## コンテナ内のフォルダ構成
## /work
##   package.json
##   package-lock.json
##   node_modules/
##
## ## 補足

## 引数をチェックする
if [ ! $# = 1 ]; then
  echo "Usage: sh init-clasp.sh {project name}"
  exit 1
fi
PROJECT_NAME=$1

## 1. 引数を使ってプロジェクトのフォルダをつくる
[ ! -e ${PROJECT_NAME}_clasp ] && mkdir ${PROJECT_NAME}_clasp
cd ${PROJECT_NAME}_clasp

## 2. docker-compose.yaml を生成する
[ ! -e docker-compose.yaml ] && \
cat << DOCKER-COMPOSE > docker-compose.yaml
version: '3'
services:
  ${PROJECT_NAME}_app:
    container_name: ${PROJECT_NAME}_app
    build:
      context: app
    tty: true
    environment:
      - TZ=Asia/Tokyo
    volumes:
      - ./app/src:/work
DOCKER-COMPOSE

## 3. app フォルダをつくる
[ ! -e app ] && mkdir app
cd app

## 4. app フォルダにDockerfile を生成する
[ ! -e Dockerfile ] && \
cat << DOCKERFILE > Dockerfile
FROM node:latest
WORKDIR /work
RUN cd /work && \
    npm init -y && \
    npm i -g @google/clasp && \
    npm i -g @types/google-apps-script
DOCKERFILE

## 5. コンテナを起動する
[ ! -e src ] && mkdir src
cd src
docker-compose up -d

## 6. Google Workspace にログインする
echo "> # next to do"
echo "> $ cd ${PROJECT_NAME}_clasp"
echo "> $ docker-compose exec ${PROJECT_NAME}_app bash -c 'clasp login --no-localhost'"
echo "> $ docker-compose exec ${PROJECT_NAME}_app bash -c 'npm init -y'"

## 7. プロジェクトを生成
echo "> # 既存のプロジェクトを取得する場合"
echo "> $ docker-compose exec ${PROJECT_NAME}_app bash -c 'clasp clone {project id}"
echo "> # 新しいプロジェクトを作成する場合"
echo "> $ docker-compose exec ${PROJECT_NAME}_app bash -c 'clasp create --title ${PROJECT_NAME}'"
