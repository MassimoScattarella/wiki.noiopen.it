NOIOPEN_BACKUP_FOLDER := $(PWD)/backup

NOIOPEN_WIKI_DB_CONTAINER_NAME := $(shell cat .env | grep NOIOPEN_WIKI_DB_CONTAINER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_HOST := $(shell cat .env | grep NOIOPEN_WIKI_DB_HOST | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_ROOT_PASSWORD := $(shell cat .env | grep NOIOPEN_WIKI_DB_ROOT_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_NAME := $(shell cat .env | grep NOIOPEN_WIKI_DB_NAME | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_USER_NAME := $(shell cat .env | grep NOIOPEN_WIKI_DB_USER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_USER_PASSWORD := $(shell cat .env | grep NOIOPEN_WIKI_DB_USER_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_DB_BACKUP_FILE := $(NOIOPEN_WIKI_DB_NAME).sql

NOIOPEN_WIKI_CONTAINER_NAME := $(shell cat .env | grep NOIOPEN_WIKI_CONTAINER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_HOST := $(shell cat .env | grep NOIOPEN_WIKI_HOST | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_PORT := $(shell cat .env | grep NOIOPEN_WIKI_PORT | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_PROTO := $(shell cat .env | grep NOIOPEN_WIKI_PROTO | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_ADMIN_PASSWORD := $(shell cat .env | grep NOIOPEN_WIKI_ADMIN_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_WIKI_LOCAL_SETTINGS := $(PWD)/wiki/LocalSettings.php

NOIOPEN_SSO_DB_CONTAINER_NAME := $(shell cat .env | grep NOIOPEN_SSO_DB_CONTAINER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_HOST := $(shell cat .env | grep NOIOPEN_SSO_DB_HOST | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_ROOT_PASSWORD := $(shell cat .env | grep NOIOPEN_SSO_DB_ROOT_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_NAME := $(shell cat .env | grep NOIOPEN_SSO_DB_NAME | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_USER_NAME := $(shell cat .env | grep NOIOPEN_SSO_DB_USER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_USER_PASSWORD := $(shell cat .env | grep NOIOPEN_SSO_DB_USER_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_SSO_DB_BACKUP_FILE := $(NOIOPEN_SSO_DB_NAME).sql

NOIOPEN_SSO_CONTAINER_NAME := $(shell cat .env | grep NOIOPEN_SSO_CONTAINER_NAME | awk -F'=' '{print $$2}')
NOIOPEN_SSO_HOST := $(shell cat .env | grep NOIOPEN_SSO_HOST | awk -F'=' '{print $$2}')
NOIOPEN_SSO_PORT := $(shell cat .env | grep NOIOPEN_SSO_PORT | awk -F'=' '{print $$2}')
NOIOPEN_SSO_PROTO := $(shell cat .env | grep NOIOPEN_SSO_PROTO | awk -F'=' '{print $$2}')
NOIOPEN_SSO_WIKI_CLIENT_ID := $(shell cat .env | grep NOIOPEN_SSO_WIKI_CLIENT_ID | awk -F'=' '{print $$2}')
NOIOPEN_SSO_WIKI_CLIENT_SECRET := $(shell cat .env | grep NOIOPEN_SSO_WIKI_CLIENT_SECRET | awk -F'=' '{print $$2}')
NOIOPEN_SSO_ADMIN_PASSWORD := $(shell cat .env | grep NOIOPEN_SSO_ADMIN_PASSWORD | awk -F'=' '{print $$2}')
NOIOPEN_SSO_BACKUP_FILE := NoiOpen-realm.json


build:
	@echo "Building MediaWiki image"
	docker-compose build --build-arg CURRENT_UID=$(shell id -u)

	@echo "Creating LocalSettings.php from template and .env data For MediaWiki" 
	@cp $(PWD)/wiki/LocalSettings.php.template $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgServer = "$(NOIOPEN_WIKI_PROTO)://$(NOIOPEN_WIKI_HOST):$(NOIOPEN_WIKI_PORT)";' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgDBserver = "$(NOIOPEN_WIKI_DB_HOST)";' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgDBname = "$(NOIOPEN_WIKI_DB_NAME)";' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgDBuser = "$(NOIOPEN_WIKI_DB_USER_NAME)";' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgDBpassword = "$(NOIOPEN_WIKI_DB_USER_PASSWORD)";' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '$$wgOpenIDConnect_Config["$(NOIOPEN_SSO_PROTO)://$(NOIOPEN_SSO_HOST):$(NOIOPEN_SSO_PORT)/auth/realms/NoiOpen/"] = [' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '    "clientID" => "$(NOIOPEN_SSO_WIKI_CLIENT_ID)",' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '    "clientsecret" => "$(NOIOPEN_SSO_WIKI_CLIENT_SECRET)"' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)
	@echo '];' >> $(NOIOPEN_WIKI_LOCAL_SETTINGS)

	@echo "All done. Run 'make up' to create containers and start them"

up:
	docker-compose up

down:
	docker-compose down

cleanall:
	docker-compose down -v

backup_wiki_db:
	@mkdir -p $(NOIOPEN_BACKUP_FOLDER)
	docker exec $(NOIOPEN_WIKI_DB_CONTAINER_NAME) sh -c 'exec mysqldump --databases $$MYSQL_DATABASE -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' > $(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_WIKI_DB_BACKUP_FILE)

restore_wiki_db:
	docker exec -i $(NOIOPEN_WIKI_DB_CONTAINER_NAME) sh -c 'exec mysql -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' < $(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_WIKI_DB_BACKUP_FILE)

backup_sso_db:
	@mkdir -p $(NOIOPEN_BACKUP_FOLDER)
	docker exec $(NOIOPEN_SSO_DB_CONTAINER_NAME) sh -c 'exec mysqldump --databases $$MYSQL_DATABASE -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' > $(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_SSO_DB_BACKUP_FILE)

restore_sso_db:
	docker exec -i $(NOIOPEN_SSO_DB_CONTAINER_NAME) sh -c 'exec mysql -u$$MYSQL_USER -p"$$MYSQL_PASSWORD"' < $(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_SSO_DB_BACKUP_FILE)

export_sso_realm:
	@mkdir -p $(NOIOPEN_BACKUP_FOLDER)
	docker exec -it $(NOIOPEN_SSO_CONTAINER_NAME) opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=NoiOpen -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=$(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_SSO_BACKUP_FILE)

import_sso_realm:
	docker exec -it $(NOIOPEN_SSO_CONTAINER_NAME) opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=$(NOIOPEN_BACKUP_FOLDER)/$(NOIOPEN_SSO_BACKUP_FILE) -Dkeycloak.migration.strategy=OVERWRITE_EXISTING

backup_all: backup_wiki_db backup_sso_db export_sso_realm

restore_all: restore_wiki_db restore_sso_db import_sso_realm

.PHONY: build up down cleanall backup_wiki_db restore_wiki_db backup_sso_db restore_sso_db export_sso_realm import_sso_realm backup_all restore_all
