#!/bin/bash

secret="./.data/appeu.secret"

function appeusrc () {
    source "$secret"
    #echo "$EMAIL"
    #echo "$SCAN_URL"
    #echo "$API_TOKEN"
    #echo "$USER_KEY"
    export WS_USERKEY="$USER_KEY"
    export WS_APIKEY="$API_TOKEN"
    export WS_WSS_URL="$SCAN_URL"
    export WS_EMAIL="$EMAIL"
    export API_URL="$API_URL"
    export API2_URL="$API2_URL"
}

appeusrc
