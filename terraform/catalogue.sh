#!/bin/bash

# Arguments for the script
component=$1
environment=$2  # Don't use env here

# Install EPEL and Remi repository for the latest Python
yum install -y epel-release
yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

# Enable Remi repository and install Python 3.11 and related packages
yum module enable python39 -y
yum install -y python3.11 python3.11-devel python3.11-pip

# Set Python 3.11 as the default python and pip
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 1

# Verify the Python version
python3 --version
pip3 --version

# Upgrade pip and install required Python libraries
python3 -m pip install --upgrade pip
python3 -m pip install ansible botocore boto3

# Execute Ansible pull with component and environment
ansible-pull -U https://github.com/nandab1805/ansible-roles-roboshop-tf.git \
  -e component=$component \
  -e env=$environment \
  main-tf.yaml
