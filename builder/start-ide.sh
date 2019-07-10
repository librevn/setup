#!/bin/bash

C9SDK_DIR=/work/cloud9
TOOLS_INSTALL_CMD="C9SDK_INSTALL_CMD=${C9SDK_DIR}/scripts/install-sdk.sh"
C9SDK_INSTALL_CMD="${TOOLS_INSTALL_CMD} && ${C9SDK_DIR}/scripts/install-sdk.sh"

export PATH=~/.c9/node/bin:/home/user/.c9/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

touch ~/a >> /dev/null
if [ $? != 0 ]; then
        sudo chown -R user:user /work /home/user
else
        rm -f ~/a >> /dev/null
fi

if [ ! -d ${C9SDK_DIR} ]; then
        ${TOOLS_INSTALL_CMD}

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

if [ $? == 0 ]; then
        echo "=== start server"
        node ${C9SDK_DIR}/server.js -l 0.0.0.0 -p 8080 -a user:pass -w /home/user
fi

