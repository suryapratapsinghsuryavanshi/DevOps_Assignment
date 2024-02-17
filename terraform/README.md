# Terraform
It is a tool for infrastructure provisioning and building infrastructure with the help of Code known as IaC(Infrastructure as Code). The main advantage of using this kind of tool is to modify the whole infrastructure and restructure it within seconds. As par the name suggests this kind of tool provides a mechanism where we need to write scripts that provide a full functional infrastructure.

> Terraform use **Hashicorp Configuration Language (HCL)** for provisioning.

### Benefits of Terraform
- Platform independent provisioning, large no. of providers.
- Multi-Platform 
- Privilege mechanism inbuilt

### Steps to use
1. Install terraform.
```sh
choco install terraform
```
1. Connect with provider.
    1. Install Azure CLI
    1. Crating Service Principle(SP) in azure.
1. Configure with provider.
    1. az login
    1. Init the directory
1. Write scripts for infra.
    1. infra.tf
1. Provisioning infra with terraform.
```sh
# initalizing
terraform init

# validate the .tf file.
terraform validate

# Check the plan are to be executable or not.
terraform plan

# apply the terraform plan
terraform apply
```