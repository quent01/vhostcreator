#!/bin/bash
# Creation d'un vhost Apache + dir associe
#

# Folder in which all vhost will be put
# at the root of $DIR there will be FOLDER_STAGE and FOLDER_PROD
# all vhosts will be put oin one of thes folders 
# (depending on the option -s/--stage)
DIR="/var/www"
FOLDER_STAGE="stage"
FOLDER_PROD="prod"

# Folder in ou vhost that will be the web root
WEB_ROOT="public/web"

# The domain to create each vhost
# the script create only subdomains
DOMAIN="perso.tech"

# See /etc/apache2/apache2.conf
OWNER="vagrant"
GRP="vagrant"
CONF="/etc/apache2/etilconf.d"


export DIR DOMAIN CONF