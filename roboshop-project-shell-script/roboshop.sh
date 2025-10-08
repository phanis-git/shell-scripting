#!/bin/bash

# **** Before creating instances lets do configure 
# Commands are
# Command :-  aws configure 
# Access key id of IAM user in aws
# Security Id of IAM user in aws
# Default region 
# Command for checking aws configure is properly configured or not
# aws s3 ls

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
HOSTED_ZONE_ID="Z06921933AGUP8YGI3FIB"
DOMAIN_NAME="devops.phani.fun"
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
        IP_ADDRESS=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
            RECORD_NAME="$DOMAIN_NAME" # devops.phani.fun
    else 
        IP_ADDRESS=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)
            RECORD_NAME="$instance.$DOMAIN_NAME"  # ex:- mysql.devops-phani.fun
    fi
    
    echo "$instance :: $IP_ADDRESS"

#  Creates route 53 records based on env name [for create we use CREATE]

# aws route53 change-resource-record-sets \
#   --hosted-zone-id 1234567890ABC \
#   --change-batch '
#   {
#     "Comment": "Testing creating a record set"
#     ,"Changes": [{
#       "Action"              : "CREATE"
#       ,"ResourceRecordSet"  : {
#         "Name"              : "'" $ENV "'.company.com"
#         ,"Type"             : "CNAME"
#         ,"TTL"              : 120
#         ,"ResourceRecords"  : [{
#             "Value"         : "'" $DNS "'"
#         }]
#       }
#     }]
#   }
#   '

# updating Route53 records [for update we use UPSERT]

# aws route53 change-resource-record-sets \
#   --hosted-zone-id $HOSTED_ZONE_ID \
#   --change-batch '
#   {
#     "Comment": "Updating record set"
#     ,"Changes": [{
#       "Action"              : "UPSERT"
#       ,"ResourceRecordSet"  : {
#         "Name"              : "'$RECORD_NAME'"
#         ,"Type"             : "A"
#         ,"TTL"              : 1
#         ,"ResourceRecords"  : [{
#             "Value"         : "'$IP_ADDRESS'"
#         }]
#       }
#     }]
#   }
# #   '

# updating Route53 record

    aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch '
  {
    "Comment": "Updating record set"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$RECORD_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }
  '
done

