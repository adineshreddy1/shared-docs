#!/bin/bash

export FABRIC_CFG_PATH=/etc/hyperledger/fabric


CC_NAME=p2p
VER=1
CHANNEL_NAME=docs-share-channel

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem

echo "========== Instantiating chaincode v$VER =========="
peer chaincode instantiate -o orderer.docsshare.com:7050  \
                           --tls $CORE_PEER_TLS_ENABLED     \
                           --cafile $ORDERER_CA             \
                           -C $CHANNEL_NAME                 \
                           -n $CC_NAME                      \
                           -c '{"Args": ["Init"]}'          \
                           -v $VER                          \
			   -l golang                        \
                           -P "OR ('bngMSP.member', 'hydMSP.member')" 
