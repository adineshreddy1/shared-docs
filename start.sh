

cd network
./dockerup.sh

cd -
cd app

echo "******Installing fabric-client********"
npm install fabric-client


npm install
rm -rf key-store-bng key-store-hyd

echo "********************************************Enroll admin for bng********************************************"
node enrollbng.js



echo "********************************************Enroll admin for hyd********************************************"
node enrollhyd.js

echo "********************************************register admin for bng********************************************"
node registerUserbng.js

echo "********************************************register admin for hyd********************************************"
node registerUserhyd.js


echo "********************************************Server starting on port:********************************************"
node server.js

cd -
