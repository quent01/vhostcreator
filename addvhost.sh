#!/bin/bash

source "config.sh"
source "vendors/alerts.sh"

STAGE=0
DELETE=0
VHOST=""

program_name=$0

usage() {
	if [ -n "$1" ]; then
		alert_error "$1"
	fi
	alert_warning "usage: ${program_name} [-n/--name vhostname] [-s/--stage] [-d/--delete newvhost] [-h/--help]"
	alert_warning "  Creation d'un vhost dans Apache et d'un dossier associé"
	alert_warning "  Le dossier sera créé dans ${DIR}"
	alert_warning "  Le nom du vhost sera vhost.${DOMAIN} ou vhost.stage.${DOMAIN} (cela dépendra de l'option -s)"
	alert_line
	alert_warning "  -n/--name : nom du vhost (ne pas préciser le fullname)"
	alert_warning "    exple : addvhost -n test créera test.${DOMAIN}"
	alert_line
	alert_warning "  -d/--delete : Supprime le vhost (ne pas préciser le fullname)"
	alert_warning "    exple : addvhost -d -n test supprimera test.${DOMAIN}"
	alert_warning "    exple : addvhost -d -n test -s stage supprimera test.stage.${DOMAIN}"
	alert_line
	alert_warning "  -s/--stage : indique qu'il s'agit d'un environement de staging"
	alert_warning "    exple : addvhost -s test créera ${DIR}/stage/test.stage.${DOMAIN}"
	alert_warning "    exple : addvhost test créera ${DIR}/prod/test.${DOMAIN}"
	alert_line

	alert_info "Liste des vhosts configuré : "
	find "${DIR}/" -type d -name "*.${DOMAIN}" | while read -r i
		do
		alert_info "$(basename "$i")"
	done
	alert_line
	
	exit 0
}

while [[ "$#" -gt 0 ]]; do case $1 in
  	-n|--name) VHOST="$2"; shift 2;;
	-d|--delete) DELETE=1; shift;;
	-s|--stage)  STAGE=1; shift;;
	-h|--help) usage;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) usage "Unexpected option: $1."; shift 2;;
esac; done

# VERIFY PARAMS
# if vhost Length is zero
if [[ -z "${VHOST}" ]]; then usage "Vhost name is not set"; fi;

if [[ "${STAGE}" = "1" ]]; then
	vhostfull="${VHOST}.${FOLDER_STAGE}.${DOMAIN}"
	path_vhost="${DIR}/${FOLDER_STAGE}/${vhostfull}"
	vhost_webroot="${path_vhost}/${WEB_ROOT}"
else
	vhostfull="${VHOST}.${DOMAIN}"
	path_vhost="${DIR}/${FOLDER_PROD}/${vhostfull}"
	vhost_webroot="${path_vhost}/${WEB_ROOT}"
fi

conf_vhost="${CONF}/${vhostfull}"

# setup prod or stage 
if [[ "${DELETE}" = "1" ]];then
	#if File is readable
	if [[ -r "${conf_vhost}" ]]; then
		rm "${conf_vhost}"
		alert_success "${conf_vhost} supprimé"
	fi
	# if File is a directory
	if [[ -d "${path_vhost}" ]]; then
		rm -r "${path_vhost}"
		alert_success "${path_vhost} supprimé"
	fi
else
	touch "${conf_vhost}"
	cat "apache2/vhost" > "${conf_vhost}"
	sed -i "s|%vhostfull%|${vhostfull}|" "${conf_vhost}"
	sed -i "s|%vhost_webroot%|${vhost_webroot}|" "${conf_vhost}"
	alert_success "${conf_vhost} créé"
	mkdir -p "${path_vhost}"
	# chown "${OWNER}:${GRP}" "${path_vhost}"
	alert_success "${path_vhost} créé"
fi

# /etc/init.d/apache2 restart
