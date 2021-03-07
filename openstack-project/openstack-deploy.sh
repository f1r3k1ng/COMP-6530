#!/bin/bash

KEY_NAME="rsa-key"
NEW_KEY=true

ROUTER_NAME="project-router"
NETWORK="public1"
NEW_ROUTER=true

EXTERNAL_NET="external-network"
EXTERNAL_SUB="external-subnet"
EXTERNAL_RANGE="10"
NEW_EXTERNAL=true

INTERNAL_NET="internal-network"
INTERNAL_SUB="internal-subnet"
INTERNAL_RANGE="20"
NEW_INTERNAL=true

SECURE_NET="secure-network"
SECURE_SUB="secure-subnet"
SECURE_RANGE="30"
NEW_SECURE=true

STORAGE_NET="storage-network"
STORAGE_SUB="storage-subnet"
STORAGE_RANGE="40"
NEW_STORAGE_NET=true

MANAGEMENT_NAME="management"
MANAGEMENT_IP="10"
NEW_MANAGEMENT=true

CONTROLLER_NAME="controller"
CONTROLLER_IP="20"
NEW_CONTROLLER=true

COMPUTE_NAME="compute"
COMPUTE_IP="30"
NEW_COMPUTE=true

STORAGE_NAME="storage"
STORAGE_IP="40"
NEW_STORAGE=true

if [ $NEW_KEY = true ]
then
	echo -e "\nCreating a new key pair\n"
	ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
	echo -e "\nAdding public key to openstack\n"
	openstack keypair create --public-key ~/.ssh/id_rsa.pub $KEY_NAME
fi

echo -e "\nCreating network $EXTERNAL_NET\n"
openstack network create "$EXTERNAL_NET" --disable-port-security
echo -e "\nCreating subnet $EXTERNAL_SUB\n"
openstack subnet create "$EXTERNAL_SUB" --network "$EXTERNAL_NET" --subnet-range "$EXTERNAL_RANGE.0.0.0/24" --dns-nameserver 8.8.8.8 --gateway "$EXTERNAL_RANGE.0.0.1"
echo -e "\nCreating port for $MANAGEMENT_NAME node on $EXTERNAL_NET\n"
openstack port create --network "$EXTERNAL_NET" --fixed-ip "subnet=$EXTERNAL_SUB,ip-address=$EXTERNAL_RANGE.0.0.$MANAGEMENT_IP" "$EXTERNAL_SUB-$MANAGEMENT_NAME-port" --disable-port-security


echo -e "\nCreating a router\n"
openstack router create "$ROUTER_NAME"
echo -e "\nAdding external gateway\n"
openstack router set "$ROUTER_NAME" --external-gateway "$NETWORK"
echo -e "\nAdding interface $EXTERNAL_SUB to $ROUTER\n"
openstack router add subnet "$ROUTER_NAME" "$EXTERNAL_SUB"
echo -e "\nAllocating a floating ip\n"
openstack floating ip create "$NETWORK"
openstack floating ip list --format csv > temp.csv
FLOATING_IP=$(cat temp.csv | awk -F, 'FNR == 2 {print $2}' | tr -d '"')
rm temp.csv

echo -e "\nCreating network $INTERNAL_NET\n"
openstack network create "$INTERNAL_NET" --disable-port-security
echo -e "\nCreating subnet $INTERNAL_SUB\n"
openstack subnet create "$INTERNAL_SUB" --network "$INTERNAL_NET" --subnet-range "$INTERNAL_RANGE.0.0.0/24" --dns-nameserver 8.8.8.8 --gateway None
echo -e "\nCreating port for $MANAGEMENT_NAME node on $INTERNAL_NET\n"
openstack port create --network "$INTERNAL_NET" --fixed-ip "subnet=$INTERNAL_SUB,ip-address=$INTERNAL_RANGE.0.0.$MANAGEMENT_IP" "$INTERNAL_SUB-$MANAGEMENT_NAME-port" --disable-port-security
echo -e "\nCreating port for $CONTROLLER_NAME node on $INTERNAL_NET\n"
openstack port create --network "$INTERNAL_NET" --fixed-ip "subnet=$INTERNAL_SUB,ip-address=$INTERNAL_RANGE.0.0.$CONTROLLER_IP" "$INTERNAL_SUB-$CONTROLLER_NAME-port" --disable-port-security
echo -e "\nCreating port for $COMPUTE_NAME node on $INTERNAL_NET\n"
openstack port create --network "$INTERNAL_NET" --fixed-ip "subnet=$INTERNAL_SUB,ip-address=$INTERNAL_RANGE.0.0.$COMPUTE_IP" "$INTERNAL_SUB-$COMPUTE_NAME-port" --disable-port-security
echo -e "\nCreating port for $STORAGE_NAME node on $INTERNAL_NET\n"
openstack port create --network "$INTERNAL_NET" --fixed-ip "subnet=$INTERNAL_SUB,ip-address=$INTERNAL_RANGE.0.0.$STORAGE_IP" "$INTERNAL_SUB-$STORAGE_NAME-port" --disable-port-security

echo -e "\nCreating network $SECURE_NET\n"
openstack network create "$SECURE_NET" --disable-port-security
echo -e "\nCreating subnet $SECURE_SUB\n"
openstack subnet create "$SECURE_SUB" --network "$SECURE_NET" --subnet-range "$SECURE_RANGE.0.0.0/24" --dns-nameserver 8.8.8.8 --gateway None
echo -e "\nCreating port for $MANAGEMENT_NAME node on $SECURE_NET\n"
openstack port create --network "$SECURE_NET" --fixed-ip "subnet=$SECURE_SUB,ip-address=$SECURE_RANGE.0.0.$MANAGEMENT_IP" "$SECURE_SUB-$MANAGEMENT_NAME-port" --disable-port-security
echo -e "\nCreating port for $CONTROLLER_NAME node on $SECURE_NET\n"
openstack port create --network "$SECURE_NET" --fixed-ip "subnet=$SECURE_SUB,ip-address=$SECURE_RANGE.0.0.$CONTROLLER_IP" "$SECURE_SUB-$CONTROLLER_NAME-port" --disable-port-security
echo -e "\nCreating port for $COMPUTE_NAME node on $SECURE_NET\n"
openstack port create --network "$SECURE_NET" --fixed-ip "subnet=$SECURE_SUB,ip-address=$SECURE_RANGE.0.0.$COMPUTE_IP" "$SECURE_SUB-$COMPUTE_NAME-port" --disable-port-security
echo -e "\nCreating port for $STORAGE_NAME node on $SECURE_NET\n"
openstack port create --network "$SECURE_NET" --fixed-ip "subnet=$SECURE_SUB,ip-address=$SECURE_RANGE.0.0.$STORAGE_IP" "$SECURE_SUB-$STORAGE_NAME-port" --disable-port-security

echo -e "\nCreating network $STORAGE_NET\n"
openstack network create "$STORAGE_NET" --disable-port-security
echo -e "\nCreating subnet $STORAGE_SUB\n"
openstack subnet create "$STORAGE_SUB" --network "$STORAGE_NET" --subnet-range "$STORAGE_RANGE.0.0.0/24" --dns-nameserver 8.8.8.8 --gateway None
echo -e "\nCreating port for $CONTROLLER_NAME node on $STORAGE_NET\n"
openstack port create --network "$STORAGE_NET" --fixed-ip "subnet=$STORAGE_SUB,ip-address=$STORAGE_RANGE.0.0.$CONTROLLER_IP" "$STORAGE_SUB-$CONTROLLER_NAME-port" --disable-port-security
echo -e "\nCreating port for $COMPUTE_NAME node on $STORAGE_NET\n"
openstack port create --network "$STORAGE_NET" --fixed-ip "subnet=$STORAGE_SUB,ip-address=$STORAGE_RANGE.0.0.$COMPUTE_IP" "$STORAGE_SUB-$COMPUTE_NAME-port" --disable-port-security
echo -e "\nCreating port for $STORAGE_NAME node on $STORAGE_NET\n"
openstack port create --network "$STORAGE_NET" --fixed-ip "subnet=$STORAGE_SUB,ip-address=$STORAGE_RANGE.0.0.$STORAGE_IP" "$STORAGE_SUB-$STORAGE_NAME-port" --disable-port-security

echo -e "\nCreating the $MANAGEMENT_NAME server\n"
openstack server create --flavor os-gw-st-flavor --image ubuntu20 --key-name $KEY_NAME --port "$EXTERNAL_SUB-$MANAGEMENT_NAME-port" --port "$INTERNAL_SUB-$MANAGEMENT_NAME-port" --port "$SECURE_SUB-$MANAGEMENT_NAME-port" "$MANAGEMENT_NAME"

echo -e "\nCreating the $CONTROLLER_NAME server\n"
openstack server create --flavor os-cont-comp-flavor --image ubuntu20 --key-name $KEY_NAME --port "$INTERNAL_SUB-$CONTROLLER_NAME-port" --port "$SECURE_SUB-$CONTROLLER_NAME-port" --port "$STORAGE_SUB-$CONTROLLER_NAME-port" "$CONTROLLER_NAME"

echo -e "\nCreating the $COMPUTE_NAME server\n"
openstack server create --flavor os-cont-comp-flavor --image ubuntu20 --key-name $KEY_NAME --port "$INTERNAL_SUB-$COMPUTE_NAME-port" --port "$SECURE_SUB-$COMPUTE_NAME-port" --port "$STORAGE_SUB-$COMPUTE_NAME-port" "$COMPUTE_NAME"

echo -e "\nCreating the $STORAGE_NAME server\n"
openstack server create --flavor os-gw-st-flavor --image ubuntu20 --key-name $KEY_NAME --port "$INTERNAL_SUB-$STORAGE_NAME-port" --port "$SECURE_SUB-$STORAGE_NAME-port" --port "$STORAGE_SUB-$STORAGE_NAME-port" "$STORAGE_NAME"

echo -e "\nWaiting for servers to finish building\n"
sleep 30s
echo -e "\nAssociating floating ip with $MANAGEMENT_NAME\n"
openstack server add floating ip "$MANAGEMENT_NAME" "$FLOATING_IP"
