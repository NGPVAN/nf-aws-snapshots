#!/bin/bash


attachment=$1
description=$2

if [ -z "$attachment" ]; then
    echo "Usage: $0 <attachment location, ex: sdf> <description>"
    exit 1
fi

if [ -z "$description" ]; then
    echo "Usage: $0 <attachment location, ex: sdf> <description>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

VOL=`ec2-describe-volumes \
    --filter="attachment.instance-id=$AWS_INSTANCE_ID" \
| grep "${attachment}" \
| awk ' { print $2 }'`

ec2-create-snapshot $VOL --description "${description}"

