#!/bin/bash

REGION=${1:-eu-west-2}
USER_DATA=file://user_data.sh
KEY_NAME=vpn_key

GROUP_ID=`aws ec2 describe-security-groups --region ${REGION} --query 'SecurityGroups[0].GroupId'`
SUBNET_ID=`aws ec2 describe-subnets --region ${REGION} --query 'Subnets[0].SubnetId'`
KEY_DATA=`aws ec2 create-key-pair --key-name ${KEY_NAME} --region ${REGION} --query 'KeyMaterial'`
# TODO: install key data as SSH private key for running remote commands
# TODO: list AMIs by region looking for specific AMI name
AMI_ID=

INSTANCE_DATA=`aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type t2.nano --key-name ${KEY_NAME} --user-data ${USER_DATA} --security-group-ids ${GROUP_ID} --subnet-id ${SUBNET_ID} --query 'Instances[0].{instance_id: InstanceId, host: PublicDnsName}' --region ${REGION}`
INSTANCE_ID=

# TODO: wait for shutdown signal

aws ec2 terminate-instances --instance-ids ${INSTANCE_ID} --region ${REGION}
aws ec2 delete-key-pair --key-name ${KEY_NAME} --region ${REGION}
