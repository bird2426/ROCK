#!/bin/bash

# Container cleanup function
setup_container_cleanup() {
    PID=$1
    CONTAINER_NAME=$2
    echo "ray actor pid is $PID"

    nohup bash -c "
        while [ -e /proc/$PID ]; do
            sleep 1
        done
        docker stop $CONTAINER_NAME
    " > /dev/null 2>&1 &
}

setup_container_cleanup "$@"
echo "start container cleanup success"