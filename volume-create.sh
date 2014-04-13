#!/bin/bash

zone=$1
description=$2

if [ -z "$zone" ]; then
    echo "Usage: $0 <availabliity zone to create volume, ex: us-west-1c> <snapshot description to search for>"
    exit 1
fi

if [ -z "$description" ]; then
    echo "Usage: $0 <availabliity zone to create volume, ex: us-west-1c> <snapshot description to search for>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

to_create=`ec2-describe-snapshots \
        --filter="description=${description}" \
        --filter="status=completed" \
    | sort -rk4 \
    | head -n1 \
    | awk '{ print $1 }'
`

for i in $to_create; do
   ec2-create-volume --snapshot $i --availability-zone ${zone}
done

