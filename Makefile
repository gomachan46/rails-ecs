include help.mk

## コンテナを初期化して一から作り直す
init:
	echo '環境一発でつくれるタスク'

## コンテナを立ち上げる
up:
	docker-compose up -d --build

ps:
	docker-compose ps

console:
	docker-compose run puma bash
