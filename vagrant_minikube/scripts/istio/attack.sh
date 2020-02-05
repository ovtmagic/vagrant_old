#!/bin/bash


tps=${1:-10}


run(){
    local n=${tps}
    while [[ $n -gt 0 ]]
    do
        #echo $n
        #curl -s localhost/productpage > /dev/null &
        curl -s http://localhost/ > /dev/null &
        n=$(( n - 1 ))
    done
}


while true
do
    run
    sleep 1
done