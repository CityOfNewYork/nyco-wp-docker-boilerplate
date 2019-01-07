#!/bin/sh
# Deployment script that you can run from anywhere in this project

# Example commands:
# bin/deploy.sh
# ../bin/deploy.sh

# get the absolute path of deploy.sh
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# get parent directory of script
BASE_PATH=$(dirname "$SCRIPT_PATH")

# source the environmental variables and scripts
source "${SCRIPT_PATH}/config.sh"
source "${SCRIPT_PATH}/headers.sh"
source "${SCRIPT_PATH}/functions.sh"

# create an array of all the projects the user has listed in .env
ARR=(${!PROJ_*})

###################
# Execute the functions
welcomeHead



# prompt user for action
echo "\nWhat do you want to do?"
echo "[0] Deploy"
echo "[1] Sync"
echo "[2] Update"
printf "Selection: "
read selection
if [[ $selection == 0 ]]; then
  deployHead
  # prompt user for target project
  destProj
  echo "You selected:" $userProj

  deploy_cmd="${SCRIPT_PATH}/git-push.sh -i ${userProj}"
  echo "\nWhich branch would you like to push to ${!ARR[$userProj]}?"
  BRANCHES=($(git branch | grep "[^* ]+" -Eo))
  for i in ${!BRANCHES[@]}
  do
    echo [$i] ${BRANCHES[i]}
  done
  printf "Selection: "
  read selected_branch

  echo "You chose ${BRANCHES[selected_branch]}"
  deploy_cmd="${deploy_cmd} -b ${BRANCHES[selected_branch]}"
  
  echo "\nWould you like to push to staging or production"
  echo "[0] staging"
  echo "[1] production"
  printf "Selection: "
  read num_env
  if [[ $num_env == 0 ]]; then
    selected_env="staging"
  elif [[ $num_env == 1 ]]; then
    selected_env="production"
  else
    echo "You did not make a valid selection... Exting"
    exit 1
  fi
  echo "You chose the environment ${selected_env}"
  deploy_cmd="${deploy_cmd} -e ${selected_env}"

  echo "\nWould you like to include a message?"
  echo "[0] Yes"
  echo "[1] No"
  printf "Selection: "
  read num_msg
  if [[ $num_msg == 0 ]]; then
    printf "Enter your message: "
    read selected_msg
    selected_msg="-m \"${selected_msg}\""
  elif [[ $num_msg == 1 ]]; then
    selected_msg=""
  else
    echo "You did not make a valid selection... Exting"
    exit 1
  fi
  echo "You chose the message ${selected_msg}"
  deploy_cmd="${deploy_cmd} ${selected_msg}"


  echo "\nWould you like to force this push?"
  echo "[0] Yes"
  echo "[1] No"
  printf "Selection: "
  read num_force
  if [[ $num_force == 0 ]]; then
    selected_force="-f true"
  elif [[ $num_force == 1 ]]; then
    selected_force=""
  else
    echo "You did not make a valid selection... Exting"
    exit 1
  fi
  echo "You chose to force push ${selected_force}"
  deploy_cmd="${deploy_cmd} ${selected_force}"
  echo "\nYou're all set. The following command will be executed:\n"
  echo "${deploy_cmd}\n"
  eval $deploy_cmd

# ###
elif [[ $selection == 1 ]]; then
	syncHead
  # prompt user for target project
  destProj
  echo "You selected:" $userProj

  deploy_cmd="${SCRIPT_PATH}/git-push.sh -i ${userProj}"
	echo "[0] Upload config.yml"
	echo "[1] Download uploads"
	printf "Selection: "
	read selection2
	if [[ $selection2 == 0 ]]; then
		source $SCRIPT_PATH/rsync-config.sh $userProj
	elif [[ $selection2 == 1 ]]; then
		source $SCRIPT_PATH/rsync-uploads.sh $userProj
	fi
# ###
elif [[ $selection == 2 ]]; then
	updateHead
	coreUpdate
else
	echo "Nothing was selected... exiting."
	exit 1
fi