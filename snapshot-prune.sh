#!/bin/bash

keep=$1
description=$2

if [ -z "$keep" ]; then
    echo "Usage: $0 <number to keep, ex: 7> <description to search for>"
    exit 1
fi

if [ -z "$description" ]; then
    echo "Usage: $0 <number to keep, ex: 7> <description to search for>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

to_delete=`ec2-describe-snapshots \
        --filter="description=${description}" \
        --filter="status=completed" \
    | sort -k4 \
    | head -n-${keep} \
    | awk '{ print $2 }'
`

for i in $to_delete; do
    ec2-delete-snapshot $i
done

