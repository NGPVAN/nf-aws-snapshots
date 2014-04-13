#!/bin/bash

size=$1

if [ -z "$size" ]; then
    echo "Usage: $0 <size of volume, ex: 200>"
    exit 1
fi

source "$(dirname -- $(type -P "$0"))/environment.sh"

to_delete=`ec2-describe-volumes \
        --filter="status=available" \
        --filter="size=${size}" \
        --filter="attachment.status=detached" \
    | sort -rk7 \
    | head -n1 \
    | awk '{ print $2 }'
`

for v in $to_delete; do
   ec2-delete-volume $v -i
done

