#!/bin/bash

set -o nounset
set -o errexit

function has_complete_env
{
    set +o nounset

    ECODE=0;

    if [ -z "$EC2_HOME" ]; then
        echo "EC2_HOME not set." >&2
        ECODE=1
    fi
    if [ -z "$JAVA_HOME" ]; then
        echo "JAVA_HOME not set." >&2
        ECODE=1
    fi
    if [ -z "$AWS_ACCESS_KEY" ]; then
        echo "AWS_ACCES_KEY not set." >&2
        ECODE=1
    fi
    if [ -z "$AWS_SECRET_KEY" ]; then
        echo "AWS_SECRET_KEY not set." >&2
        ECODE=1
    fi

    set -o nounset

    exit $ECODE
}

if [ -x "/etc/ec2.sh" ]; then
    source /etc/ec2.sh
    EC2_LOADED=0
else
    EC2_LOADED=1
fi

(has_complete_env)
if [ "$?" -ne 0 ]; then
    echo "Could not initialize the environment completely." >&2
    if [ "$EC2_LOADED" -ne 0 ]; then
        echo "Could not load /etc/ec2.sh." >&2
    else
        echo "Did load /etc/ec2.sh" >&2
    fi

    exit 1
fi


export PATH=$PATH:$EC2_HOME/bin

# Derive common data from the instance
AWS_INSTANCE_ID=`ec2metadata --instance-id`

id_region_url="http://169.254.169.254/latest/dynamic/instance-identity/document"
AWS_REGION=`curl "${id_region_url}" | grep region | cut -d\" -f4`

export AWS_INSTANCE_ID
export AWS_REGION

# Authentication Options
export EC2_URL="https://ec2.${AWS_REGION}.amazonaws.com"


