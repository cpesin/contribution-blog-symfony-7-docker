#!/bin/bash
set -e

### CREATE DIRECTORIES / SET PERMISSIONS ###
echo ::: $(date) :::
echo :::::::::::::::: SET PERMISSIONS ::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# See https://symfony.com/doc/current/setup/file_permissions.html
mkdir -p var
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var

echo "PERMISSIONS SET successfully"

### RUN APACHE ###
echo ::: $(date) :::
echo :::::::::::::::: RUN APACHE :::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
bash apache2-foreground

echo :::::::::::::::: FINISHED ::::::::::::::::::::
