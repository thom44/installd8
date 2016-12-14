#!/bin/bash

echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'FINISH DRUPAL CORE '$DRUPAL_VERSION' INSTALLATION ' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

echo 'DRUPAL_ROOT = '$DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
echo 'DRUPAL_USER = '$DRUPAL_USER 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

if prompt_yes_no "Do you want to fix the permissions and run fix-perm.sh script" ; then
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo 'FIX PERMISSIONS ON '$DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo '==================================================' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	echo 'run ./fix-perm.sh setup '$DRUPAL_USER':'$DRUPAL_GROUP $DRUPAL_ROOT 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
	$PATH_TO_SELF/fix-perm.sh $DRUPAL_ROOT $DRUPAL_USER $DRUPAL_GROUP 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
fi

echo 'SET PERMISSION sites/default/settings.php to 440' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log
chmod 440 $DRUPAL_ROOT"/sites/default/settings.php" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

chmod 644 $DRUPAL_ROOT"/sites/default/files/.htaccess" 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log

echo 'DONE' 2>&1 | tee -a $PATH_TO_SELF/logs/install-$now.log


