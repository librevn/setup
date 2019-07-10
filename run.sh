#!/bin/bash

# change it up to what you need
SHARED_DIR=`pwd`

# map shared folder to container
VOLUME_OPT="-v /${SHARED_DIR}/shared/work:/work -v ${SHARED_DIR}/shared/home:/home/user"

# route port 8080 (container) to 80 (host)
PORT_OPT="-p 80:8080"

# set container name hence we can stop via its name instead of auto-gen magic id
CONTAINER_NAME="cloud9-ide"

# if existed, kill, warning message may print if container had not yet start,
# just ignore it
docker stop ${CONTAINER_NAME} > /dev/null

# now we can start
# there is an option where we want to test container, by input '/bin/bast' letting
# us to access to container shell (instead of start cloud9 starting script)
if [ -z "$1" ]; then
	if [ ! -d ${SHARED_DIR}/work/cloud9 ]
		echo "=== install cloud9, once it'd done, it will be possible to run as daemon"
		docker run --rm -it ${VOLUME_OPT} ${PORT_OPT} --name ${CONTAINER_NAME} cloud9:latest /usr/local/bin/start-cloud9
	else
		docker run --rm -d ${VOLUME_OPT} ${PORT_OPT} --name ${CONTAINER_NAME} cloud9:latest
	fi
else
	docker run --rm -it ${VOLUME_OPT} ${PORT_OPT} --name ${CONTAINER_NAME} cloud9:latest $*
fi


