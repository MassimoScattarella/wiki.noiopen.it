up:
	docker-compose up

in:
	docker exec -ti wiki bash

build:
	docker-compose build --build-arg CURRENT_UID=$(shell id -u)

dev: build up

restore:
	cp -v backup/*.sqlite data/
	cat backup/noiopen.sqlite-*.bin >data/noiopen.sqlite

backup:
	./backup.sh

setup:
	id -u | grep 0
	-systemctl stop caddy
	-systemctl start wiki.service
	-docker-compose kill
	crontab $(shell pwd)/crontab
	cp wiki.service /etc/systemd/system
	systemctl enable wiki.service
	systemctl start wiki.service
	cp Caddyfile /etc/caddy/Caddyfile
	systemctl start caddy
	systemctl enable caddy

.PHONY: all up in build dev backup restore setup
