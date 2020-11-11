# Apache vhostcreator

## Description

- Command line to create vhost for dev purpose (it create the folder and the vhost in apache)
- Only handle subdomains
- Subdomains are put in two différents folders ```$FOLDER_STAGE``` or ```$FOLDER_PROD```

## Utilisation

- copy ```config/config.sample.sh``` to ```config/config.sh```
- copy ```config/apache2/vhost.sample``` to ```config/apache2/vhost```
- edit ```config/config.sh```
- (not required) edit ```config/apache2/vhost```

```bash
# Display help
sudo ./addvhost.sh -h
sudo ./addvhost.sh --help

# Create $DIR/$FOLDER_PROD/subdomain.$DOMAIN
sudo ./addvhost.sh -n subdomain
sudo ./addvhost.sh --name subdomain

# Create $DIR/$FOLDER_STAGE/subdomain.$FOLDER_STAGE/$DOMAIN
sudo ./addvhost.sh -n subdomain -s
sudo ./addvhost.sh --name subdomain --stage

# Delete $DIR/$FOLDER_PROD/subdomain.$DOMAIN
sudo ./delvhost -n subdomain
sudo ./delvhost --name subdomain

# Delete $DIR/$FOLDER_PROD/subdomain.$FOLDER_STAGE.$DOMAIN
sudo ./delvhost -n subdomain -s
sudo ./delvhost --name subdomain --stage
```