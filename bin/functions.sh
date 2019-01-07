#!/bin/sh
# functions.sh
# Contains functions:
# destProj - prompts the user to select project
# coreUpdate - updates the WordPress core based on composer.json
# Usage:
# bin/functions.sh <instance>

#####
# prompt the user for which project they would like to use
function destProj() {
	echo "What is the project destination?"
	for i in ${!ARR[@]}
	do
		echo [$i] ${!ARR[i]}
	done
	printf "Selection: "
	read choice

	# set the destination project
	userProj=${!ARR[choice]}
}

###
# update the wordpress core
function coreUpdate(){
	# define base directory 
	baseDir="$(dirname "${SCRIPT_PATH}")"
	echo "Base directory is:" $baseDir

	# create temp directory
	tempDir=$baseDir/temp
	mkdir $tempDir

	# assign the project directory
	projDir=$baseDir/wp
	echo $projDir

	echo '>Copying .git and .gitignore to temporary directory'
	cp -R $projDir/.git $baseDir
	cp $projDir/.gitignore $tempDir
	echo '>>>DONE!'

	echo '>Copying wp-config.php to temporary directory'
	cp $projDir/wp-config.php $tempDir
	echo '>>>DONE!'

	echo '>Copying composer.json to temporary directory'
	cp $projDir/composer.json $tempDir
	cp $projDir/composer.lock $tempDir
	echo '>>>DONE!'

	echo '>Copying README.md to temporary directory'
	cp $projDir/README.md $tempDir

	echo '>Copying wp-content to the temporary directory'
	cp -R $projDir/wp-content $tempDir
	echo '>>>DONE!'

	echo '>Running composer install'
	composer install
	echo '>>>DONE!'

	echo '>Moving the .git and .gitignore to the project directory'
	mv $tempDir/.git $projDir/
	mv $tempDir/.gitignore $projDir/
	echo '>>>DONE!'

	echo '>Moving wp-config.php to the project directory'
	mv $tempDir/wp-config.php $projDir/
	echo '>>>DONE!'

	echo '>Moving the plugins composer.json to the project directory'
	mv $tempDir/composer.json $projDir/
	mv $tempDir/composer.lock $projDir/
	echo '>>>DONE!'

	echo '>Moving the README.md to the project directory'
	mv $tempDir/README.md $projDir/
	echo '>>>DONE!'

	echo '>Removing the wp-content/ built by composer'
	rm -r $projDir/wp-content
	echo '>>>DONE!'

	echo '>Moving wp-content/ to the project directory'
	cp -R $tempDir/wp-content $projDir/
	echo '>>>DONE!'

	echo '>Removing vendor and composer.lock from base directory'
	rm -r $baseDir/vendor
	rm $baseDir/composer.lock
	echo '>>>DONE!'

	# # remove the tempDir
	# if [ -z "$(ls -A $baseDir/temp)" ]; then
	# 	echo ">Temporary directory is empty... Removing."
	# 	rmdir $tempDir
	# else
	#    echo "ERROR!"
	#    echo ">Temporary directory is not empty... Keeping."
	# fi
	
	# removing the temporary wp-content/
	rmdir $tempDir/wp-content

	# mission complete
	echo '>Updating wordpress core...'
	echo 'COMPLETE!'
}