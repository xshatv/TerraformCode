# TerraformCode
#this repo is for terrform codes only.

# Installation & Configuration of terraform & supporting applications

1. Install Terraform by following: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2. Configuring AWS CLI
  - Install AWS CLI by following https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  - create an new user with AdministrativeAccess in console and Generate Access key & Sercret Access Key
  - run in server, aws configure        # provide the details asked.
  - above details will be stored inside ".aws" directory.

3. Create an folder & put terraform code in ".tf" format.

4. terraform init                                                  => initializes the terraform, installs the providers inside .terrform
                                                                    .terraform/providers/registry.terraform.io/hashicorp/aws/5.38.0/linux_amd64
5. terraform validate                                              => validates the code if it is correct or not
6. terraform plan                                                  => generates the following plans that will get updated.
7. terraform apply                                                 => applies the code in the provider's console.

