#!/bin/bash
cd "$(dirname $0)"
date
docker exec -i wiki php /var/www/html/maintenance/sqlite.php --backup-to /var/www/backup/noiopen.sqlite
cd backup
rm -f noiopen.sqlite-*
split -b 99M --additional-suffix=.bin noiopen.sqlite noiopen.sqlite- 
cd ..
git add images/ backup/
git commit -m "Backup $(date)" -a
git push origin master
