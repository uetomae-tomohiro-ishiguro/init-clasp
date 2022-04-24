#!/bin/bash

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
