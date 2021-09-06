#!/bin/bash

function get_dc_env() {
  sed -n -e "/${1}/ s/.*\= *//p" .env
}

function fill_placeholder() {
  sed -ri "s~$1~$2~" .env
}

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit
ENV_FILE=.env
#Check if env file exists and offer to recreate it
if [ -f "$ENV_FILE" ]; then
  echo "The .env file already exists."
  read -r -p "Would you like to remove it? (Y|N): " -i 'N' -e REMOVE_ENV_FILE
  if [ "${REMOVE_ENV_FILE^^}" == 'Y' ]; then
    rm .env
    cp .env.template .env
  fi
else
  cp .env.template .env
fi

#Ask user to type base paths
CURRENT_DIR=$PWD
PARENT_DIR=$(dirname "$PWD")

if grep -q @PATH_TO_PROJECT@ ".env"; then
  read -r -p "Type the project path: " -i "$PARENT_DIR" -e PROJECT_PATH
  fill_placeholder "@PATH_TO_PROJECT@" "$PROJECT_PATH"
else
  PROJECT_PATH=$(get_dc_env PROJECT_PATH)
fi

COMPOSE_PROJECT_NAME=${PROJECT_PATH%*/}

if grep -q @YOUR_PROJECT_NAME@ ".env"; then
  read -r -p "Type the project name: " -i "$(sed s~-~_~g <<<${COMPOSE_PROJECT_NAME##*/})" -e COMPOSE_PROJECT_NAME
  fill_placeholder "@YOUR_PROJECT_NAME@" "$COMPOSE_PROJECT_NAME"
else
  COMPOSE_PROJECT_NAME=$(get_dc_env COMPOSE_PROJECT_NAME)
fi

if grep -q @YOUR_PROJECT_DOMAIN@ ".env"; then
  read -r -p "Type the domain for project: " -i "${COMPOSE_PROJECT_NAME}.loc" -e PROJECT_DOMAIN
  fill_placeholder "@YOUR_PROJECT_DOMAIN@" "$PROJECT_DOMAIN"
else
  PROJECT_DOMAIN=$(get_dc_env DOMAIN)
fi

if grep -q @PATH_TO_DOCKER_DATA@ ".env"; then
  read -r -p "Type the path to docker data: " -i "$CURRENT_DIR/data" -e DATA_PATH
  fill_placeholder "@PATH_TO_DOCKER_DATA@" "$DATA_PATH"
else
  DATA_PATH=$(get_dc_env DATA_PATH)
fi

if grep -q @PATH_TO_LOGS@ ".env"; then
  read -r -p "Type the log path: " -i "$CURRENT_DIR/logs" -e LOGS_PATH
  fill_placeholder "@PATH_TO_LOGS@" "$LOGS_PATH"
else
  LOGS_PATH=$(get_dc_env LOGS_PATH)
fi

for TMP in "tmp" "tmp/php_sessions"; do
  mkdir -p "./$TMP"
done

for DIRECTORY in "supervisor" "mysql" "nginx" "php"; do
  mkdir -p "$LOGS_PATH/$DIRECTORY"
done

#Create public directory
if [ ! -d "${PROJECT_PATH}/public" ]; then
  read -r -p "Create public folder with index.php? " -i 'Y' -e CREATE_PUBLIC
  if [ "${CREATE_PUBLIC^^}" == 'Y' ]; then
    mkdir "${PROJECT_PATH}/public" && echo '<?php phpinfo();' >"${PROJECT_PATH}/public/index.php"
  fi
fi

read -p -r 'Download bitrix_setup.php? ' -i 'Y' -e DBS

if [ "${DBS}" == 'Y' ]; then
  wget "https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php" -O "${PROJECT_PATH}/public/bitrixsetup.php"
  echo "File is downloaded."
fi
