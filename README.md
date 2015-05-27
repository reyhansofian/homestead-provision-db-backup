# Homestead Provision with DB Backup and Import

Inspiration: [Laracast](https://laracasts.com/forum/?p=2038-vagrant-provision-databases-from-shell-script/0)

_Note: I'm using laravel homestead not only for my laravel projects, but I'm using it on all of my PHP projects_

Basically, homestead provision command will delete all your database (with all its data also) and create a fresh new database. So if you wanted to backup all your database and import all your data again, you can use this.

 1. Clone this repository
 2. Open the cloned repository folder
 3. Find Homestead.yaml file and open it using your favourite text editor or IDE
 4. Find the databases section
 
    ```
    databases:
        - name: homestead
          dumppath: /home/vagrant/development/db/homestead # The path to folder where your sql files stored
    ```
    You can copy it to your Homestead.yaml or use the Homestead.yaml I've provided. As you can see on this code, it will store the mysql dump data to folder `/home/vagrant/development/db` with sql file named homestead. Don't worry about the file extension. I've provided the code to add the extension for you on `create-mysql.sh` file.
 
 5. Find create-mysql.sh on the cloned repository folder and open it
 6. As you can see here:
    ```
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
    ```
    I've added some new line to dump all databases on your VM machine into a file. For example, if you have a database named homestead, it will create a dump file named homestead.sql an store it based on your `dumppath` on Homestead.yaml databases section.
    
    Copy this file to your homestead scripts folder. Unfortunately, I'm using Linux Ubuntu 14.04 right now, so my homestead scripts folder will be on `~/.composer/vendor/laravel/homestead/scripts`.
 7. Find homestead.rb on the cloned repository folder and copy it to your homestead scripts folder.
 8. Do `homestead provision` and find your imported db files on `/home/vagrant/development/db`
 9. ***REMEMBER!!!*** Always backup your files before you use this. Use at your own risk.
