#!/bin/bash

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
echo $FABRIC_CFG_PATH

CC_NAME=p2p
VER=1
CHANNEL_NAME=docs-share-channel
DELAY=5
COUNTER=1
MAX_RETRY=20

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute current Scenario ==========="
    echo
    exit 1
  fi
}

# peer0.bng Installing chaincode in
echo "========== Installing chaincode in peer0.bng.com to channel $CHANNEL_NAME =========="
sleep 20
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bng.com/users/Admin@bng.com/msp
CORE_PEER_ADDRESS=peer0.bng.com:7051
CORE_PEER_LOCALMSPID=bngMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bng.com/peers/peer0.bng.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

# peer1.bng Installing chaincode in
echo "========== Installing chaincode in peer1.bng.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bng.com/users/Admin@bng.com/msp
CORE_PEER_ADDRESS=peer1.bng.com:8051
CORE_PEER_LOCALMSPID=bngMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/bng.com/peers/peer1.bng.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode

# peer0.hyd Installing chaincode in
echo "========== Installing chaincode in peer0.hyd.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hyd.com/users/Admin@hyd.com/msp
CORE_PEER_ADDRESS=peer0.hyd.com:7451
CORE_PEER_LOCALMSPID=hydMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hyd.com/peers/peer1.hyd.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

# peer1.hyd Installing chaincode in
echo "========== Installing chaincode in peer1.hyd.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hyd.com/users/Admin@hyd.com/msp
CORE_PEER_ADDRESS=peer1.hyd.com:8451
CORE_PEER_LOCALMSPID=hydMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hyd.com/peers/peer1.hyd.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

echo""
echo "==================================== DONE ======================================"
echo""

