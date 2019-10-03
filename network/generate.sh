#!/bin/bash


export IMAGE_TAG=latest
export PATH=${PWD}/../bin:${PWD}:$PATH

echo "************************Generating of Crypto-config certificates***"
./bin/cryptogen generate --config=./crypto-config.yaml

echo "************************Generation of channel-artifacts*************"

mkdir channel-artifacts

./bin/configtxgen -profile ThreeOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block 
./bin/configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID docs-share-channel 
./bin/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/bngMSPanchors.tx -channelID  docs-share-channel -asOrg bngMSP
./bin/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/hydMSPanchors.tx -channelID  docs-share-channel -asOrg hydMSP
./bin/configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/chnMSPanchors.tx -channelID  docs-share-channel -asOrg chnMSP


for Org  in bng hyd chn ;
do
cp $Org.yaml.tmp $Org.yaml 
done


ARCH=$(uname -s | grep Darwin)
if [ "$ARCH" == "Darwin" ]; then
  OPTS="-it"
  rm -rf *.yamlt
else
  OPTS="-i"
fi


CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/bng.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA_bng_KEY/${PRIV_KEY}/g" bng.yaml

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/hyd.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA_hyd_KEY/${PRIV_KEY}/g" hyd.yaml

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/chn.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA_chn_KEY/${PRIV_KEY}/g" chn.yaml