# Provisioning Linux NFS Server and Client with Terraform

This project automates the setup of a Linux NFS server and NFS client using Terraform on AWS. It includes provisioning essential AWS infrastructure components like VPC, subnet, gateway, route table, security groups, and EC2 instances. Additionally, Python and Bash scripts facilitate fetching the latest Amazon Linux AMI and preparing Ansible directories, respectively.

## Features

- Automated provisioning of VPC, subnet, gateway, route table, route association, and security groups on AWS.
- Configuration of EC2 instances with the latest Amazon Linux AMI using Terraform.
- Integration of Python script (`retrieve_latest_ami.py`) to fetch the most recent Amazon Linux AMI for Terraform.
- Preparation of Ansible directories using a Bash script (`prereq`).
- Setup of NFS server and client configurations using Ansible playbooks.
- Creation of shared directories and validation of NFS sharing functionality.

## Scripts

- `retrieve_latest_ami.py`: Fetches the latest Amazon Linux AMI using Boto3 for Terraform provisioning.
- `prereq`: Prepares Ansible directories for playbook execution.
- `create_and_configure.sh`: Automates environment setup, runs Terraform commands, and executes Ansible playbooks (`NFS_Setup.yml`) to configure NFS server and client.
