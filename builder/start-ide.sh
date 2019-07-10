#!/bin/bash

C9SDK_DIR=/work/cloud9
TOOLS_INSTALL_CMD="sudo apt-get update && sudo apt-get install git wget python2.7 build-essential -y"
C9SDK_INSTALL_CMD="${TOOLS_INSTALL_CMD} && ${C9SDK_DIR}/scripts/install-sdk.sh"

export PATH=/home/user/.c9/bin:/home/user/.c9/node/bin:/home/user/.c9/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

touch /home/user/a >> /dev/null
if [ $? != 0 ]; then
        sudo chown -R user:user /work /home/user
else
        rm -f /home/user/a >> /dev/null
fi

if [ ! -d ${C9SDK_DIR} ]; then
        eval ${TOOLS_INSTALL_CMD}

        echo "=== clone cloud9-sdk"
        git clone https://github.com/c9/core.git ${C9SDK_DIR} >> /dev/null
        
        eval ${C9SDK_INSTALL_CMD}
fi

echo "=== install addition tools if need"
if [ ! -d /home/user/.c9 ]; then
        eval ${C9SDK_INSTALL_CMD}
fi

tmux -V >> /dev/null
if [ $? != 0 ]; then
        # last installation seem not yet completed, reinstall
        eval ${C9SDK_INSTALL_CMD} 
fi

node --version >> /dev/null
if [ $? != 0 ]; then
        # last installation seem not yet completed, reinstall
        eval ${C9SDK_INSTALL_CMD}
fi

if [ $? == 0 ]; then
        echo "=== start server"
        node ${C9SDK_DIR}/server.js -l 0.0.0.0 -p 8080 -a user:pass -w /home/user
fi

