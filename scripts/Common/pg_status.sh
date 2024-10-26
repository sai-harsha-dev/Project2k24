#!/bin/bash      
  
BLUE='[34m'
RED='[31m'
GREEN='[32m'

status(){
    while  kill -0 $3 2> out.log;
    do
    echo -ne "\e${BLUE}${4}..."
    echo -ne "\r"
    sleep 0.2
    done

    if [ $1 -ne 0 ];
        then
        echo -e "\e${RED}\rERROR: $(cat <2)"
        exit 0
    else
        echo -e "\e${GREEN}\rSUCCESS: $2"
        return 0
    fi
}