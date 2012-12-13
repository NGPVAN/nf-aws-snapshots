# Put this file into /etc/ec2.sh for sourcing from the other scripts. Make sure
# this file is secured, and non-root users cannot access it.

# Note that this should not contain the path to the bin, but to the root
# of the extracted directory.

export EC2_HOME=/path/to/ec2-api-tools/
export JAVA_HOME=/usr # Commonly in /usr
export AWS_ACCESS_KEY=""
export AWS_SECRET_KEY=""

