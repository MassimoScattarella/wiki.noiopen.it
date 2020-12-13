# MediaWiki with Keycloak integration for NoiOpen
This branch implements integration between MediaWiki and Keycloak. It's not still perfect, but it works.
## Development environment
You need:
- docker
- docker-compose
- make
- git

What you have to do is:
- git clone of this repo
- git checkout feature/mariadb-sso-integration
- cp .env.example .env
- make build
- make up

If you haven't modified any value in **.env**, then you will have:
- a Keycloak available at [http://noiopen_sso:8080](http://noiopen_sso:8080) (admin user: **noiopen_sso**, admin pass: **noiopen_sso_pass**, wiki admin user: **Noiopen**, wiki admin user password: **noiopen_wiki_pass**)
- a MediaWiki available at [http://noiopen_wiki:8081](http://noiopen_wiki:8081) 

**IMPORTANT NOTE 1**: insert in your **/etc/hosts** *noiopen_wiki* and *noiopen_sso* entries pointing to localhost, otherwise you will not be able to reach the services.

**IMPORTANT NOTE 2**: The scripts that update informations taken from **.env** file are not still tested or implemented, so please do not modify the data inside that file.

### Makefile targets
You have different Makefile targets:
- **build**: create MediaWiki custom image and prepare configuration scripts for containers;
- **up**: like *docker-compose up* (create and start all containers);
- **down**: like *docker-compose down* (stop and remove all containers **except for the database volumes**);
- **cleanall**: like *docker-compose down -v* (stop and remove all containers **AND their volumes)**;
- **clean_images**: deletes custom MediaWiki image generated from *make build*;
- **backup_wiki_db**: Backup MediaWiki database to *backup* folder;
- **restore_wiki_db**: Restore MediaWiki database from *backup* folder;
- **backup_sso_db**: Backup Keycloak database to *backup* folder; 
- **restore_sso_db**: Restore Keycloak database from *backup* folder;
- **export_sso_realm**: Export *NoiOpen* realm to *backup* folder (with users and clients); Press *CTRL+C* at the end of the operation to conclude it (check stdout for export results);
- **import_sso_realm**: Import *NoiOpen* realm from *backup* folder (with users and clients); Press *CTRL+C* at the end of the operation to conclude it (check stdout for import results);
- **backup_all**: Call all backup targets (including exporting realm);
- **restore_all**: Call all restore targets (including importing realm);
# Production environment
To be implemented.
