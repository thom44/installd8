#! /bin/bash

### Display Install Settings
echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'INSTALL DRUPAL CORE '$DRUPAL_VERSION' WITH THE FOLLOWING CONFIGURATIONS'  2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'RUN THIS SCRIPT WITH ROOT PERMISSIONS!'
echo 'PROJECT_ROOT='$PROJECT_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'DRUPAL_DIR='$DRUPAL_DIR 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'DRUPAL_ROOT='$DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'PATH_TO_DRUSH='$PATH_TO_DRUSH 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'DRUPAL_USER:DRUPAL_GROUP '$DRUPAL_USER':'$DRUPAL_GROUP 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'Development Domain: '$SITE_DOMAIN 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'Install Type Git clone' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

if prompt_yes_no "Do you want to install the core now" ; then 

    cd $PROJECT_ROOT;                                       
    git clone --branch $DRUPAL_VERSION https://git.drupal.org/project/drupal.git $DRUPAL_DIR 2>&1 | tee -a

    chown -R $DRUPAL_USER:$DRUPAL_GROUP $PROJECT_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
    cd $DRUPAL_DIR;
    git remote rename origin drupalorg 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
  
    composer install

    echo 'drupal core install at '$DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log                                                     
    chown -R $DRUPAL_USER:$DRUPAL_GROUP $PROJECT_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
    cd $PROJECT_ROOT;
fi

if prompt_yes_no "Do you want prepare filesiystem for Browserinstallation" ; then

	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo ' START WITH PREPARING DEFAULT INSTALLATION' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	echo 'Create files Directory:' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo $DRUPAL_ROOT"/sites/default/files/translations" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	mkdir -p $DRUPAL_ROOT"/sites/default/files/translations" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	chmod -R g+w $DRUPAL_ROOT"/sites/default/files" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	echo 'Create default settings.php' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	cp $DRUPAL_ROOT"/sites/default/default.settings.php" $DRUPAL_ROOT"/sites/default/settings.php"  2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	chmod 666 $DRUPAL_ROOT"/sites/default/settings.php" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
		
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo $PROJECT ' COMPLETED'; 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	
	echo 'SET FILESYSTEM USER TO '$DRUPAL_USER':'$DRUPAL_GROUP 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	chown -R $DRUPAL_USER:$DRUPAL_GROUP $PROJECT_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo 'DONE' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	echo '*** FOR SECURITY ***' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo ' ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo 'PLEASE ENTER THE FOLLOWING LINES TO YOUR APACHE CONFIG FILE' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo 'to prevent the execution of php files in files directories' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '=========================================================== ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	echo ' ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '<Directory '$DRUPAL_ROOT'/sites/default/files>' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '  SetHandler default-handler' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '  Options None' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '  Options +FollowSymLinks' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '  AllowOverride None' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '</Directory>' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo ' ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	
	echo '===========================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo ' ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	
	
fi
