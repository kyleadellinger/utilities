#!/bin/bash

## TODO shell script to retrieve secret values and pass them to UA to execute

## base command: java -jar "path-to-jar" -c "path-to-config" -d "directory-to-be-scanned" -apiKey API_KEY -userKey USER_KEY -product PRODUCT_NAME -project PROJECT_NAME -wss_url WSS_URL

PATH_TO_AGENT="/home/ubuntu/wss-unified-agent.jar"
PATH_TO_CONFIG="/home/ubuntu/wss-unified-agent.config"
DIRECTORY_TO_SCAN="$1"
PRODUCT_NAME="$2"
PROJECT_NAME="$3"

function appsrc () {
    source ~/basher/envs/.data/app.secret
    #echo "$EMAIL"
    #echo "$SCAN_URL"
    #echo "$API_TOKEN"
    #echo "$USER_KEY"
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function appeusrc (){
    source ~/basher/envs/.data/appeu.secret
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function saassrc () {
    source ~/basher/envs/.data/saas.secret
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function saaseusrc() {
    source ~/basher/envs/.data/saaseu.secret
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function mendsaassrc() {
    source ~/basher/envs/.data/mendsaas.secret
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function mendsaaseusrc () {
    source ~/basher/envs/.data/mendsaaseu.secret
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
}

function selection (){
    echo "Select Environment."
    echo -e "1. APP \n2. APP-EU\n3. SAAS\n4. SAAS-EU\n5. Mend SAAS\n6. Mend SAAS-EU"
    read -p "selection: " my_select
    if [ "$my_select" = "1" ]
    then
    appsrc
    elif [ "$my_select" = "2" ]
    then
    appeusrc
    elif [ "$my_select" = "3" ]
    then
    saassrc
    elif [ "$my_select" = "4" ]
    then
    saaseusrc
    elif [ "$my_select" = "5" ]
    then
    mendsaassrc
    elif [ "$my_select" = "6" ]
    then
    mendsaaseusrc
    else
    echo "invalid selection."
    fi
}

function scancommand () {
    java -jar "$PATH_TO_AGENT" -c "$PATH_TO_CONFIG" -d "$DIRECTORY_TO_SCAN" -product "$PRODUCT_NAME" -project "$PROJECT_NAME"
}

selection
scancommand
