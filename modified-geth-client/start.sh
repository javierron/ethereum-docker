#!/bin/bash
set -e -x
cd /root/eth-net-intelligence-api
perl -pi -e "s/XXX/$(hostname)/g" app.json
/usr/local/bin/pm2 start ./app.json
sleep 3
geth --datadir=~/.ethereum/devchain init "/root/files/genesis.json"
sleep 3
LOCAL_IP=`getent hosts $(hostname) | awk '{ print $1 }'`
GETH_OPTS=${@/LOCAL_IP/$LOCAL_IP}
geth $GETH_OPTS
