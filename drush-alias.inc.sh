#!/bin/bash

# ADD DRUSHALIAS CONFIGURATION
#ALIAS_FILE=$PATH_TO_DRUSHALIAS"/"$PROJECT".aliases.drushrc.php";

echo "<?php" 2>&1 | tee -a $ALIAS_FILE;
echo "/**" 2>&1 | tee -a $ALIAS_FILE;
echo " * "$PROJECT".aliases.drushrc.php for $PROJECT site on LOCALSERVER" 2>&1 | tee -a $ALIAS_FILE;
echo -e " */\n" 2>&1 | tee -a $ALIAS_FILE;
echo -e "// $PROJECT ON LOCALSERVER (local)\n" 2>&1 | tee -a $ALIAS_FILE;
echo "\$aliases['$DEV_ALIAS'] = array(" 2>&1 | tee -a $ALIAS_FILE;
echo "		'uri' => '$PROJECT.local'," 2>&1 | tee -a $ALIAS_FILE;
echo "		'root' => '$DRUPAL_ROOT'," 2>&1 | tee -a $ALIAS_FILE;
echo "    	'path-aliases' => array(" 2>&1 | tee -a $ALIAS_FILE;
echo "			'%drush' 		=> '$PATH_TO_DRUSH'," 2>&1 | tee -a $ALIAS_FILE;
echo "			'%dump-dir' 	=> '/home/thom/dumps/'," 2>&1 | tee -a $ALIAS_FILE;
echo "			'%dump' 		=> '/home/thom/dumps/$PROJECT.local_' . date('Y-m-d_H-i-s') . '.sql'," 2>&1 | tee -a $ALIAS_FILE;
echo "			'%site' 		=> 'sites/default'," 2>&1 | tee -a $ALIAS_FILE;
echo "			'%files' 		=> 'sites/default/files'," 2>&1 | tee -a $ALIAS_FILE;
echo "    )," 2>&1 | tee -a $ALIAS_FILE;
echo "    'databases' =>" 2>&1 | tee -a $ALIAS_FILE;
echo "      array (" 2>&1 | tee -a $ALIAS_FILE;
echo "       'default' =>" 2>&1 | tee -a $ALIAS_FILE;
echo "        array (" 2>&1 | tee -a $ALIAS_FILE;
echo "          'default' =>" 2>&1 | tee -a $ALIAS_FILE;
echo "          array (" 2>&1 | tee -a $ALIAS_FILE;
echo "            'driver' => 'mysql'," 2>&1 | tee -a $ALIAS_FILE;
echo "            'username' => '$DB_USER'," 2>&1 | tee -a $ALIAS_FILE;
echo "            'password' => '$DB_PASSWD'," 2>&1 | tee -a $ALIAS_FILE;
echo "            'port' => ''," 2>&1 | tee -a $ALIAS_FILE;
echo "            'host' => 'localhost'," 2>&1 | tee -a $ALIAS_FILE;
echo "            'database' => '$DB_NAME'," 2>&1 | tee -a $ALIAS_FILE;
echo "          )," 2>&1 | tee -a $ALIAS_FILE;
echo "       )," 2>&1 | tee -a $ALIAS_FILE;
echo "     )," 2>&1 | tee -a $ALIAS_FILE;
echo "    'command-specific' => array (" 2>&1 | tee -a $ALIAS_FILE;
echo "    	'pm-download' => array(" 2>&1 | tee -a $ALIAS_FILE;
echo "            'destination' => 'modules/contrib'," 2>&1 | tee -a $ALIAS_FILE;
echo "            ),  " 2>&1 | tee -a $ALIAS_FILE;
echo "    )," 2>&1 | tee -a $ALIAS_FILE;
echo -e ");\n" 2>&1 | tee -a $ALIAS_FILE;

