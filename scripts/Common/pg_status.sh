#!/bin/bash      
  
BLUE='\033[0:34m'
RED='\033[0:31m'
GREEN='\033[0:32m'

status(){
    while  kill -0 $3 2> out.log;
    do
    echo -ne '\E[101M]'"${BLUE}${4}..."
    echo -ne "\r"
    sleep 0.5
    done

    if [ $1 -ne 0 ];
        then
        echo -e "${RED}\rERROR: $(cat <2)"
        exit 0
    else
        echo -e "${GREEN}\rSUCCESS: $2"
        return 0
    fi
}