# MediaWiki, Keycloak and Discourse for NoiOpen

You need docker, docker-compose, make and git 

On production server you also need caddy and cron

# Development

- git clone of this repo
- git checkout feature/mariadb-sso-integration
- cp .env.example .env
- make build
- make up

If you haven't modified any value in .env, then you will have:
- a Keycloak available at http://noiopen_sso:8080 (admin user: noiopen_sso, admin pass: noiopen_sso_pass, wiki user: noiopen_wiki, wiki user password: noiopen_wiki_pass)
- a MediaWiki available at http://noiopen_wiki:8081 (admin user: noiopen_wiki, admin pass: noiopen_wiki_pass) still configured in local authentication without Keycloak
- a Discourse (to be implemented) at http://localhost:8082 (at the moment, only the client in Keycloak realm is present)

Please insert in your /etc/hosts noiopen_wiki and noiopen_sso entries pointing to localhost, otherwise you will not be able to reach the services.

# Makefile targets

You have different Makefile targets:
- build: create mediawiki custom image and prepare configuration scripts for containers
- up: like docker-compose up (create and start all containers)
- down: like docker-compose down (stop and remove all containers except for the database volumes)
- cleanall: like docker-compose down -v (stop and remove all containers and their volumes)
- backup_wiki_db: Backup MediaWiki database to wiki_db/dump folder;
- restore_wiki_db: Restore MediaWiki database from wiki_db/dump folder;
- backup_sso_db: Backup Keycloak database to sso_db/dump folder; Press CTRL+C at the end of the operation;
- restore_sso_db: Restore Keycloak database from sso_db/dump folder; Press CTRL+C at the end of the operation;
- export_sso_realm: Export NoiOpen realm to sso/dump folder (with users and clients);
- import_sso_realm: Import NoiOpen realm from sso/dump folder (with users and clients);
- backup_all: call all backup targets (including exporting realm)
- restore_all: call all restore targets (including importing realm)

# Production (!!! NOT READY !!!)

To be tested (never done). Old informations follow:

- create an user noiopen 
- git clone this repo as `/home/noiopen/wiki.noiopen.it` with an url allowing git push back (as we backup in git)
- create a .env file and add GMAIL_AUTH=xxx where xxx is an app password to send emails
- `make restore` to restore the database
- `sudo make setup` to setup: 
  - caddy
  - cron job for the backup 
  - systemd service

  Also you need that wiki.noiopen.it points to the server, obviously

