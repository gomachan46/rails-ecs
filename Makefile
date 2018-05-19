include help.mk
.PHONY: init up ps console db/init db/migrate _clean
RUNNER := docker-compose run --rm

## コンテナを初期化して一から作り直す
init:
	$(MAKE) _clean
	docker-compose build
	docker-compose up -d
	$(MAKE) db/init

## コンテナを立ち上げる
up:
	docker-compose up -d
	$(MAKE) bundle/install
	$(MAKE) db/migrate

test:
	$(RUNNER) puma bundle exec rspec

## コンテナの状況確認
ps:
	docker-compose ps

## rails動作環境へSSH
console:
	$(RUNNER) puma bash

rails/console:
	$(RUNNER) puma rails c

db/console:
	$(RUNNER) puma rails db -p

## DBを初期化(drop, create, migrate)
db/init:
	$(RUNNER) puma rails db:drop db:create db:migrate

## migrate状態を最新に
db/migrate:
	$(RUNNER) puma rails db:migrate

bundle/install:
	$(RUNNER) puma bundle install --jobs=4 --path=/bundle

## コンテナ群をvolumeごとdown
_clean:
	docker-compose down -v
