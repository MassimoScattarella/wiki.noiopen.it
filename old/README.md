# MediaWiki for NoiOpen

You need docker, docker-compose, make and git 

On production server you also need caddy and cron

# Development

- git clone of this repo
- make restore
- make up

Then go to http://localhost:8080/wiki/Pagina_Principale

# Production

- create an user noiopen 
- git clone this repo as `/home/noiopen/wiki.noiopen.it` with an url allowing git push back (as we backup in git)
- create a .env file and add GMAIL_AUTH=xxx where xxx is an app password to send emails
- `make restore` to restore the database
- `sudo make setup` to setup: 
  - caddy
  - cron job for the backup 
  - systemd service

  Also you need that wiki.noiopen.it points to the server, obviously


