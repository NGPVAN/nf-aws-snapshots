#!/bin/bash

keep=$1
description=$2
region=$3

if [ -z "$keep" ]; then
    echo "Usage: $0 <number to keep, ex: 7> <description to search for>"
    exit 1
fi

if [ -z "$description" ]; then
    echo "Usage: $0 <number to keep, ex: 7> <description to search for>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

if [ -z "$region" ]; then
   region=${AWS_REGION};
fi

to_delete=`ec2-describe-snapshots \
        --region=${region} \
        --filter="description=${description}" \
        --filter="status=completed" \
    | sort -k4 \
    | head -n-${keep} \
    | awk '{ print $2 }'
`

for i in $to_delete; do
    ec2-delete-snapshot --region=${region} $i
done

