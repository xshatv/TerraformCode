#!/bin/bash
sudo snap install aws-cli --classic
aws --version
echo "=================> AWS CLI installation done, now installing Terraform"
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
echo "-----------------> Installing HashiCorp GPG key: "
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "-----------------> Verify the fingerprint"
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "-----------------> Add the officail HashiCorp Repo to your system"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
echo "-----------------> Download the package from HashiCorp."
sudo apt update
echo "-----------------> Install terraform"
sudo apt-get install terraform -y
