#!/bin/bash

C9SDK_DIR=/work/cloud9
C9SDK_INSTALL_CMD=${C9SDK_DIR}/scripts/install-sdk.sh

export PATH=~/.c9/node/bin:/home/user/.c9/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

touch ~/a >> /dev/null
if [ $? != 0 ]; then
	sudo chown -R user:user /work /home/user
else
	rm -f ~/a >> /dev/null
fi

if [ ! -d ${C9SDK_DIR} ]; then
        git --version >> /dev/null
        if [ $? != 0 ]; then
		echo "=== install required tools"
                sudo apt-get install git wget python2.7 build-essential -y >> /dev/null
        fi
	
	echo "=== clone cloud9-sdk"
        git clone https://github.com/c9/core.git ${C9SDK_DIR} >> /dev/null
fi

echo "=== install addition tools if need"
if [ ! -d ~/.c9 ]; then
        ${C9SDK_INSTALL_CMD}
fi

tmux -V >> /dev/null
if [ $? != 0 ]; then
        ${C9SDK_INSTALL_CMD} 
fi

node --version >> /dev/null
if [ $? != 0 ]; then
        ${C9SDK_INSTALL_CMD}
fi

sed -i "s/auth\[0\]/\"user\"/g" ${C9SDK_DIR}/configs/standalone.js
sed -i "s/auth\[1\]/\"Pass1234\!\@\#\$\"/g" ${C9SDK_DIR}/configs/standalone.js

if [ $? == 0 ]; then
	echo "=== start server"
        node ${C9SDK_DIR}/server.js -l 0.0.0.0 -p 8080 -a a:a -w /home/user
fi

