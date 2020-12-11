$(eval BASENAME := $(shell basename "`pwd`"))

WIKI_DB_CONTAINER_NAME := noiopen_wiki_db
WIKI_DB_DUMP_FOLDER := $(PWD)/wiki_db/dump
WIKI_DB_DUMP_FILE := $(WIKI_DB_CONTAINER_NAME).sql

SSO_DB_CONTAINER_NAME := noiopen_sso_db
SSO_DB_DUMP_FOLDER := $(PWD)/sso_db/dump
SSO_DB_DUMP_FILE := $(SSO_DB_CONTAINER_NAME).sql

SSO_CONTAINER_NAME := noiopen_sso
SSO_CONTAINER_DUMP_FOLDER := /dump
SSO_DUMP_FOLDER := $(PWD)/sso/dump
SSO_DUMP_FILE := NoiOpen-realm.json

up:
	docker-compose up

down:
	docker-compose down

cleanall:
	docker-compose down -v

backup_wiki_db:
	@mkdir -p $(WIKI_DB_DUMP_FOLDER)
	docker exec $(WIKI_DB_CONTAINER_NAME) sh -c 'exec mysqldump --databases $$MYSQL_DATABASE -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' > $(WIKI_DB_DUMP_FOLDER)/$(WIKI_DB_DUMP_FILE)

restore_wiki_db:
	docker exec -i $(WIKI_DB_CONTAINER_NAME) sh -c 'exec mysql -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' < $(WIKI_DB_DUMP_FOLDER)/$(WIKI_DB_DUMP_FILE)

backup_sso_db:
	@mkdir -p $(SSO_DB_DUMP_FOLDER)
	docker exec $(SSO_DB_CONTAINER_NAME) sh -c 'exec mysqldump --databases $$MYSQL_DATABASE -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' > $(SSO_DB_DUMP_FOLDER)/$(SSO_DB_DUMP_FILE)

restore_sso_db:
	docker exec -i $(SSO_DB_CONTAINER_NAME) sh -c 'exec mysql -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' < $(SSO_DB_DUMP_FOLDER)/$(SSO_DB_DUMP_FILE)

export_sso_realm:
	@mkdir -p $(SSO_DUMP_FOLDER)
	docker exec -it $(SSO_CONTAINER_NAME) opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=NoiOpen -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=$(SSO_CONTAINER_DUMP_FOLDER)/$(SSO_DUMP_FILE)

import_sso_realm:
	docker exec -it $(SSO_CONTAINER_NAME) opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=$(SSO_CONTAINER_DUMP_FOLDER)/$(SSO_DUMP_FILE) -Dkeycloak.migration.strategy=OVERWRITE_EXISTING

.PHONY: up down cleanall backup_wiki_db restore_wiki_db backup_sso_db restore_sso_db export_sso_realm import_sso_realm
