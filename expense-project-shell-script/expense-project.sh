#!/bin/bash

# creating ec2 instance by aws cli or command
    # aws ec2 run-instances \
    # --image-id ami-0abcdef1234567890 \
    # --instance-type t2.micro \
    # --count 1 \
    # --key-name MyKeyPairName \
    # --security-group-ids sg-0abcdef1234567890 \
    # --subnet-id subnet-0abcdef1234567890 \
    # --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyNewInstance}]' \

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0d61951953429eeed"


# create instances dynamically
for instance in "$@"
do 
    # Creating instance and get instance id
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id "$AMI_ID" \
        --instance-type t3.micro \
        --security-group-ids "$SG_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text)

    # Getting public/private IP based on instance type
    if [ "$instance" == "frontend" ]; then
        ID=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
    else 
        ID=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)
    fi
    
    echo "$instance :: $ID"
done
