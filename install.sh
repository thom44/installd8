#!/bin/bash

now=$(date +"%d_%m_%Y__%H_%M_%S")

### Creates subdirectory for logfiles
LOG_DIR=$PATH_TO_SELF"/"logs

if [ ! -d $LOG_DIR ]; then
	mkdir $LOG_DIR
fi

APACHE_CONFIG_FILE=$APACHE_PREFIX$PROJECT.conf
A2FILE_PATH="/etc/apache2/sites-available/"$APACHE_CONFIG_FILE

ALIAS_FILE=$PATH_TO_DRUSHALIAS"/"$PROJECT".aliases.drushrc.php";


if [ "$1" == "--uninstall" ]; then
	#################
	### Uninstall ###
	#################
	echo '=================================================='
	echo "Uninstall $PROJECT"
	echo '=================================================='
	echo "The Drupal Root is $DRUPAL_ROOT"
	echo "The Database Name is $DB_NAME"
	echo "The Domain is $SITE_DOMAIN"

	if prompt_yes_no "Do you want uninstall Drupal on $PROJECT_ROOT" ; then
	
		a2dissite $APACHE_CONFIG_FILE
		service apache2 reload
		echo $APACHE_CONFIG_FILE" disablend"

		if prompt_yes_no "Do you want to remove apache config file $A2FILE_PATH" ; then
			if [ -f $A2FILE_PATH ]; then
				rm $A2FILE_PATH
				echo $A2FILE_PATH" removed"
			else
				echo $A2FILE_PATH" fiele not exists"
			fi

		fi
		
		if prompt_yes_no "Do you want to remove Drupal Dir $DRUPAL_ROOT" ; then
			
			cd $PROJECT_ROOT

			if [ -d $DRUPAL_DIR ]; then

				rm -rf $DRUPAL_DIR
				echo $DRUPAL_DIR" removed"
			else
				echo $DRUPAL_DIR" fiele not exists"
			fi

		fi

		if prompt_yes_no "Do you want to remove Project Dir $CUSTOMER $PROJECT_ROOT" ; then
			
			cd $PROJECT_ROOT
			cd ..

			if [ -d $CUSTOMER ]; then

				rmdir $CUSTOMER
				echo $CUSTOMER" removed"
			else
				echo $CUSTOMER" fiele not exists, or directory not empty"
			fi

		fi

		sed "$SITE_DOMAIN" /etc/hosts
		if prompt_yes_no "Do you want to remove the $SITE_DOMAIN entry in /etc/hosts file" ; then
			if [ -f /etc/hosts ]; then
				grep -v "$SITE_DOMAIN" /etc/hosts > temp && mv temp /etc/hosts
				echo "$IP	$SITE_DOMAIN removed"
			fi
		fi


		if prompt_yes_no "Do you want to DELETE DATABASE $DB_NAME" ; then
			mysql --user=$DB_USER -h localhost --password="$DB_PASSWD" -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
		fi


		if prompt_yes_no "Do you want to remove DrushAliasFile" ; then
			if [ -f $ALIAS_FILE ]; then
				rm $ALIAS_FILE;
				echo $ALIAS_FILE" removed"
			else
				echo $ALIAS_FILE" fiele not exists"
			fi
		fi
	fi

else

	###############
	### Install ###
	###############

	### Creates the Project directoy if not exists
	if prompt_yes_no "Do you want to create a new Drupal Directory $PROJECT_ROOT" ; then

	  echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  echo 'Creates Project Directory' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	  if [ ! -d $PROJECT_ROOT ]; then

		mkdir -p $PROJECT_ROOT	2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
		chmod 755 $PROJECT_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log	
		echo "$PROJECT_ROOT created" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log	 

	    else

		echo "Directory $PROJECT_ROOT exists already" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	  fi
	fi

	### Creates the database
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo "Creates Database $DB_NAME" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	if prompt_yes_no "Do you want to CREATE DATABASE $DB_NAME" ; then

		mysql --user=$DB_USER -h localhost --password="$DB_PASSWD" -Bse "CREATE DATABASE $DB_NAME;" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	fi

	echo "Install type ist $INSTALL_TYPE"

	### Run Drupal install script
	if prompt_yes_no "Do you want to install DRUPAL 8" ; then

	    
	    if [ "$INSTALL_TYPE" = "composer" ]; then
		
		echo '============= COMPOSER INSTALL ================='
		source $PATH_TO_SELF"/"core-composer-install.inc.sh
	    else
		source $PATH_TO_SELF"/"core-install.inc.sh	    	
	    fi
	fi

	### Creates module/theme contib/custom directories
	if prompt_yes_no "Do you want to create module/theme contib/custom directories" ; then
	  echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  echo 'Creates conrib/custom Directories' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	  mkdir -p $DRUPAL_ROOT"/"modules/contrib 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  mkdir -p $DRUPAL_ROOT"/"modules/custom 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  mkdir -p $DRUPAL_ROOT"/"themes/contrib 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  mkdir -p $DRUPAL_ROOT"/"themes/custom 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  chown -R $DRUPAL_USER:$DRUPAL_GROUP $DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	  echo 'conrib/custom Directories created' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	fi

	### Remove .git directory
	if prompt_yes_no "Do you want to remove .git directory now" ; then
		cd $DRUPAL_ROOT;
		rm -rf .git;
	fi


	### Creates Apache Configuration
	if prompt_yes_no "Do you want to ADD APACHE CONFIGURATIONL" ; then

	#touch $A2FILE_PATH

	echo -e '# Kunde: '$CUSTOMER' Project '$PROJECT'\n' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '<VirtualHost *:80>' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '	ServerName '$PROJECT'.local' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo -e '	ServerAdmin root@localserver.local\n' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo -e '	DocumentRoot '$DRUPAL_ROOT'\n' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo -e '	<Directory '$DRUPAL_ROOT'>\n' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo -e '	</Directory>\n' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '	LogLevel warn' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '	ErrorLog ${APACHE_LOG_DIR}/'$PROJECT'_error.log' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '	CustomLog ${APACHE_LOG_DIR}/'$PROJECT'_access.log combined' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	echo '</VirtualHost>' 2>&1 | tee -a /etc/apache2/sites-available/$APACHE_CONFIG_FILE;
	 
	a2ensite $APACHE_CONFIG_FILE
	service apache2 reload
	
	fi


	### Add Domain to hosts file
	if prompt_yes_no "Do you want to add the Domain to the /etc/hosts file" ; then
		echo "$IP	$SITE_DOMAIN" >> /etc/hosts
	fi

	### Add Trusted Hosts Directive to settings.php
	echo "\$settings['trusted_host_patterns'] = array("
	echo "  '^$PROJECT\.$TLD$',"
	echo ");"
	if prompt_yes_no "Do you want to add Trusted Hosts Directive to settings.php" ; then
		echo "\$settings['trusted_host_patterns'] = array(" >> $DRUPAL_ROOT/sites/default/settings.php
		echo "  '^$PROJECT\.$TLD$'," >> $DRUPAL_ROOT/sites/default/settings.php
		echo ");" >> $DRUPAL_ROOT/sites/default/settings.php
	fi

	### Browser install
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo -e "NOW RUN $SITE_DOMAIN/install.php FROM YOUR BROWSER!\n\n" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log


	### Run after install script
	if prompt_yes_no "Do you want to run CORE-AFTER-INSTALL SCRIPT to fix permissions" ; then
		source $PATH_TO_SELF"/"core-after-install.inc.sh
	fi


	### Creates Drush Alias
	if prompt_yes_no "Do you want to CREATE A DRUSHALIAS FILE" ; then
	    if [ ! -f "$ALIAS_FILE" ]; then
		source $PATH_TO_SELF"/drush-alias.inc.sh"
	    else
		echo "File already exists $ALIAS_FILE"
	    fi

	fi

	chown -R $DRUPAL_USER:$DRUPAL_GROUP /var/www

	### Creates a database clone
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo "Creates a Database Clone $DB_NAME" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

	if prompt_yes_no "Do you want to create a database clone $DB_NAME" ; then

		mysqldump --user=$DB_USER --password="$DB_PASSWD" $DB_NAME > $PROJECT_ROOT"/"$DB_NAME-fresh-clone.sql; 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
		echo "Datebase Clone $PROJECT_ROOT"/"$DB_NAME-fresh-clone.sql created"

	fi

fi
