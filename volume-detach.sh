#!/bin/bash

size=$1

if [ -z "$size" ]; then
    echo "Usage: $0 <size of volume, ex: 200>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

EC2_INSTANCE_ID=$(ec2metadata --instance-id)

to_detach=`ec2-describe-volumes \
        --filter="attachment.instance-id=${EC2_INSTANCE_ID}" \
        --filter="size=${size}" \
    | sort -rk7 \
    | head -n1 \
    | awk '{ print $2 }'
`

for v in $to_detach; do
   ec2-detach-volume $v
done

