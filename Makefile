include help.mk
.PHONY: init up ps console db/init db/migrate _clean

## コンテナを初期化して一から作り直す
init:
	$(MAKE) _clean
	$(MAKE) up

## コンテナを立ち上げる
up:
	docker-compose up -d --build
	$(MAKE) db/migrate

## コンテナの状況確認
ps:
	docker-compose ps

## rails動作環境へSSH
console:
	docker-compose run puma bash

## DBを初期化(drop, create, migrate)
db/init:
	docker-compose run puma rails db:drop db:create db:migrate

## migrate状態を最新に
db/migrate:
	docker-compose run puma rails db:migrate

_clean:
	docker-compose down -v
