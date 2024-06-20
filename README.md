# Terraform AWS Linux Server and Client Provisioning

This repository automates the provisioning of a Linux server and client infrastructure on AWS using Terraform. It includes setting up essential networking components, security groups, SSH key association, and leveraging Python and Ansible for streamlined configuration.

## Features

- Automatically provisions AWS VPC, subnet, gateway, route table, route association, and security groups using Terraform.
- Uses a Python script (`retrieve_latest_ami.py`) with Boto3 to fetch the latest Amazon Linux 2023 AMI for EC2 instances in Terraform.
- Prepares Ansible directories with a Bash script (`prereq.sh`) and sets up templates for server configuration roles.
- Includes a script (`create_and_configure.sh`) to orchestrate environment setup, execute Terraform commands, and run Ansible playbooks.
- Utilizes Ansible to configure server roles, including NFS setup, and provides a result to verify NFS sharing success.

## Scripts Overview

- **retrieve_latest_ami.py**: Python script using Boto3 to fetch the latest Amazon Linux 2023 AMI ID for Terraform provisioning.
  
- **prereq.sh**: Bash script to prepare Ansible directories and templates for server configuration roles.

- **create_and_configure.sh**: Bash script to orchestrate environment setup, Terraform provisioning, and Ansible playbook execution.
