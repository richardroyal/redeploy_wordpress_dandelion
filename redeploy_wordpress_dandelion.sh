#!/bin/bash

# 1. Checkout repo
# 2. Create test install with WP CLI
# 3. Update WP core and Plugins
# 4. Delete dandelion revision file on server
# 5. Deploy with dandelion

# Params:
# 
#    root folder on server
#    repo name
#
# Example:
#    ./redeploy_wordpress_site.sh www.example.com example_git_repo

echo "Reading config.cfg"
source config.cfg

# Clone Repo
mkdir tmp
cd tmp
git clone $GIT_ROOT_URL/$2.git
cd $2


# Create a tmp WP install and update core and plugins
RNAME=$(date +%s | sha256sum | base64 | head -c 8)
echo "CREATE DATABASE $RNAME;" | mysql -u $LOCAL_MYSQL_USER -p$LOCAL_MYSQL_PW

wp core config --dbname=$RNAME --dbuser=$LOCAL_MYSQL_USER --dbpass=$LOCAL_MYSQL_PW
wp core install --url=http://localhost/$RNAME --title=$RNAME --admin_user=admin --admin_password=Example123 --admin_email=no-reply@example.com
wp core update
rm -rf wp-content/themes/twenty*
git add . && git commit -am "Updated WP Core (Automated)."
wp plugin update --all
rm -f wp-content/plugins/hello.php
git add . && git commit -am "Updated WP Plugins (Automated)."
git push origin master


# Deploy a fresh set of files
echo "Deleting revision file and redeploying."
ncftp -u $FTP_USER -p $FTP_PW $FTP_HOST <<EOF
rm -f /$1/$REVISION_FILE_ROOT_PATH_SEPARATOR$REVISION_FILE_NAME
quit
EOF

dandelion deploy


# Cleanup
echo "DROP DATABASE $RNAME;" | mysql -u $LOCAL_MYSQL_USER -p$LOCAL_MYSQL_PW
cd $STARTING_DIR
rm -rf tmp/
