#!/bin/bash

#Create the rootCA files
#copy the CA Certificate and CA Key in the same folder to generate the keys
# 1. Generate the private key
#openssl ecparam -out rootCA.key -name prime256v1 -genkey
# 2. Generate the Certificate Signing Request (CSR)
#openssl req -new -sha256 -key rootCA.key -out rootCA.csr
# 3. Generate the self-signed Root CA certificate
#openssl x509 -req -sha256 -days 365 -in rootCA.csr -signkey rootCA.key -out rootCA.crt


DEVICE_NAME=$1

#Variables
DEVICE_KEY=$DEVICE_NAME".pem"
DEVICE_CSR=$DEVICE_NAME".csr"
DEVICE_CERT=$DEVICE_NAME"_Cert.pem"

ORG="Sagar Choudhary"
ORG_UNIT="Private"

CA_CERT="rootCA.crt"
CA_KEY="rootCA.key"

#Required for CSR 
country=IN
state=""
locality=""
organization=$ORG
organizationalunit=$ORG_UNIT
email=""
CN=$DEVICE_NAME

#Required for Signing Certificate
DAYS_VALID=365

mkdir $DEVICE_NAME"_Files"


# Generate the Private key for the device
echo "Generating Private key"
openssl ecparam -name prime256v1 -genkey -noout -out $DEVICE_KEY

echo "Requesting CSR"
openssl req -key $DEVICE_KEY -new -out $DEVICE_CSR -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$CN/emailAddress=$email"

echo "Printing CSR"
openssl req -text -noout -in $DEVICE_CSR

echo "Signing the Device Certificate"
openssl x509 -req -in $DEVICE_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $DEVICE_CERT -days $DAYS_VALID  -sha256
echo "Signing Complete"

#Move and delete the files
mv $DEVICE_KEY $DEVICE_CERT $DEVICE_NAME"_Files"
cp $CA_CERT $DEVICE_NAME"_Files"
rm $DEVICE_CSR

