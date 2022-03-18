#!/bin/bash

# TODO: print usage function

set -e -x

# delete data folders

ETH_DIR="$HOME/.ethereum"
GETH_DIR="$HOME/go-ethereum"
GETH_BIN_DIR="$GETH_DIR/build/bin"
GETH_BIN_NAMES=("geth-15" "geth-15")
GENESIS_FILE="$HOME/genesis.json"


N=${#GETH_BIN_NAMES[@]}

for (( VAR=0; VAR<$N; VAR++ ))
do
    GETH_BIN="$GETH_BIN_DIR/${GETH_BIN_NAMES[$VAR]}"

    DEVCHAIN_DIR="$ETH_DIR/devchain-$VAR"
    LOG_FILE="$HOME/logs/subnode-$VAR.log"
    OFFSET=`expr 3 + $VAR`
    PORT_NUMBER="3030$OFFSET"

    echo "Removing devchain dir: $DEVCHAIN_DIR"
    rm -rf $DEVCHAIN_DIR

    # echo "Reseting genesis block"
    # $GETH_BIN "--datadir=$DEVCHAIN_DIR" "init" "$GENESIS_FILE" > "$LOG_FILE" 2>&1

    echo "Starting subnode $VAR"
    export SUBNODE_ID=$VAR
    $GETH_BIN "--syncmode=full" "--maxpeers=5" "--port=$PORT_NUMBER" "--syncmode=full" "--verbosity=5" "--datadir=$DEVCHAIN_DIR" "--ropsten" "--netrestrict=172.27.0.0/24" "--nodiscover" "--nat=none" &> "$LOG_FILE" &
done