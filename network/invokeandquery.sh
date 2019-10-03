
//working invoke

//open and try this commnds in cli

//docker exec -it cli bash

peer chaincode invoke -o orderer.docsshare.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem  -C "docs-share-channel" -n p2p -c '{"Args":["Generatedocs","{\"Name\":\"Keerthana\",\"ID\":\"1\"}"]}'
//working invoke
peer chaincode invoke -o orderer.docsshare.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem  -C "docs-share-channel" -n p2p -c '{"Args":["Generatedocs","{\"Name\":\"Dinesh\",\"ID\":\"2\"}"]}'

//working query for query all docss
peer chaincode query -o orderer.docsshare.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem  -C "docs-share-channel" -n p2p -c '{"Args":["GetAlldocs"]}'


//shareing docs we need to provide docs  and sender Name

peer chaincode invoke -o orderer.docsshare.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem  -C "docs-share-channel" -n p2p -c '{"Args":["sharedocs","148726d209d7bbf2ad5019f6ea79469969f1c30ccd8df2437beca7d352fbde62","Dinesh"]}'
//query by name 
peer chaincode invoke -o orderer.docsshare.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/docsshare.com/orderers/orderer.docsshare.com/msp/tlscacerts/tlsca.docsshare.com-cert.pem  -C "docs-share-channel" -n p2p -c '{"Args":["QueryName","Keerthana"]}'

