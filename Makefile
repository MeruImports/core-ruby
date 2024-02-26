.PHONY: build console linter tests

build:
	@echo "Building app"
	docker-compose build

console:
	@echo "Starting app console"
	docker-compose run --rm app ruby bin/console

linter:
	@echo "Running linter"
	docker-compose run --rm app bundle exec standardrb

tests:
	@echo "Running tests"
	ln -sf .env.test .env && docker-compose run --rm app bundle exec rake test
