#!/bin/bash

region=$1
description=$2

if [ -z "$region" ]; then
    echo "Usage: $0 <region to copy to, ex: us-east-1> <snapshot description to search for>"
    exit 1
fi

if [ -z "$description" ]; then
    echo "Usage: $0 <region to copy to, ex: us-east-1> <snapshot description to search for>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

to_copy=`ec2-describe-snapshots \
        --filter="description=${description}" \
        --filter="status=completed" \
    | sort -k4 \
    | head -n-1 \
    | awk '{ print $2 }'
`

for i in $to_copy; do
    ec2-copy-snapshot -r ${AWS_REGION} -s $i -—region ${region}
done

