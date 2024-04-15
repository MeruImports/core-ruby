.PHONY: build console linter tests bash

build:
	@echo "Building app"
	ln -sf .env.development .env && docker-compose build

console:
	@echo "Starting app console"
	ln -sf .env.development .env && docker-compose run --rm app ruby bin/console

bash:
	@echo "Starting bash"
	ln -sf .env.development .env && docker-compose run --rm app bash

linter:
	@echo "Running linter"
	docker-compose run --rm app bundle exec standardrb

tests:
	@echo "Running tests"
	ln -sf .env.test .env && docker-compose run --rm app bundle exec rspec
