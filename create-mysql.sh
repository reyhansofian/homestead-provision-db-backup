#!/usr/bin/env bash

DB=$1;
DUMPFILE=$2; # Here is the second arguments comes from homestead.rb

echo "Exporting data to $DUMPFILE from $DB";
touch $DUMPFILE.sql; # We create the file if it's not exists
mysqldump -uhomestead -psecret -h localhost -e $DB > $DUMPFILE.sql; # Do mysqldump command

mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS \`$DB\`";
mysql -uhomestead -psecret -e "CREATE DATABASE \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";

echo "Importing data to $DB from $DUMPFILE";
mysql -uhomestead -psecret $DB < $DUMPFILE.sql; # Import the mysql data