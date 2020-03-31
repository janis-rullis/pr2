#!/bin/bash
# https://github.com/janis-rullis/shell-scripts

# Do a complete docker cleanup if there is only 1 dockerized project. Can be set - `./setup.sh 1`.
ONLY_PROECT=false;
if [[ -n $1 ]]; then
      ONLY_PROJECT=true;
fi

function init(){
  # TODO: Add some notification about causes when executed multiple times.

	echo "Define error reporting level, file seperator, and init direcotry.";
	set -e	; # set -o xtrace;
	# https://unix.stackexchange.com/a/164548 You can preserve newlines in the .env.
	IFS=$''
	DIR=$PWD;
  DIR_PHP="${DIR}/php";
  DIR_PHP_NGINX="${DIR_PHP}/build/nginx";
	ROOT_DIR="$(dirname "${DIR}")";
  ENV_FILE=".env";
}

function checkRequirements(){    
  echo "Checking if the '.env' file exists ...";

  # #17 https://github.com/janis-rullis/shell-scripts/blob/master/learn-basics/if-conditions.sh#L124
  if [[ ! -r $ENV_FILE ]]; then
    echo "'.env' file is missing!";
    echo -e "* Copy the .env.example to .env.\n* Open .env and fill values in FILL_THIS." ;
    exit;
  fi  
}

function stopDocker(){
	echo "Remove any possible past clutter."
	sudo rm db/mysql/* -R && touch db/mysql/.gitkeep

	echo "Stop any running container from this project";
	docker-compose down --remove-orphans 

	if [[ $ONLY_PROJECT = true ]]; then
		echo "Remove any dangling part."
		echo y | docker network prune
		echo y | docker image prune
		echo y | docker volume prune
	fi
}

function initDb(){
	docker-compose up -d pr2-mysql
}

function readEnvVariables(){
	echo "Reading .env variables...";
	ENV_VARS=`cat ${ENV_FILE}`
	DB_PW=`echo ${ENV_VARS} | grep MYSQL_PASSWORD= | cut -d '=' -f2`;
  DOMAIN=`echo ${ENV_VARS} | grep DOMAIN= | cut -d '=' -f2`;

  # https://superuser.com/questions/1225134/why-does-the-base64-of-a-string-contain-n/1225139
  SECRET=`openssl rand -hex 32  | tr -d \\n`
}

# #7 Set domains from .env.
function setNginxVariables(){
  ecbo "Set NGINX variables...";

  echo "Go into '${DIR_PHP_NGINX}' direcotry...";
  cd $DIR_PHP_NGINX

  echo "Copying '.site.conf.example' to 'site.conf'...";
  cp .site.conf.example site.conf

  echo "Fill variables collected from the master '.env'...";
  sed -i -e "s/FILL_DOMAIN/\${DOMAIN}\/g" site.conf

  cd $DIR;
}

# Dockerize the pr2-php.
function setPhpEnv(){
	echo "Setting up the 'pr2-php' container."
	echo "Go into '${DIR_PHP}' direcotry...";
  cd $DIR_PHP;
	echo "Copying '.env.example' to '.env'...";
	cp .env.example .env

	echo "Fill variables collected from the master '.env'...";

	sed -i -e "s/FILL_DB_PASSWORD/$DB_PW/g" .env  
  sed -i -e "s/FILL_APP_SECRET/\"${SECRET}\"/g" .env
  
	cd $DIR;
	echo "'.env' is ready.";

  echo "Initialize a clean API container first ...";
  docker-compose build --no-cache pr2-php
  docker-compose down --remove-orphans 
}

init
checkRequirements
initDb
stopDocker
readEnvVariables
setPhpEnv
echo "Setup is completed."
echo "Starting the project.."
echo "If this is the first time then it will download and setup Docker containers."
chmod a+x start.sh
./start.sh