# Infrastructure as Code with Terraform on Azure – Lab Guide

## Lab3 – Backend State

In this lab, you will learn how to move your Terraform state file to Azure Blob Storage using a backend state. At the end of this lab, you will have a better understanding of how to use Terraform backend state for state file management.

## Prerequisites
Before starting this lab, ensure you have completed lab 2.

## Lab Overview
1. Authenticate to Azure with the Azure CLI
2. Create a new storage account
3. Create a new container in the storage account
4. Configure a backend state on the newly created storage account
5. Move the state file to the backend
6. Delete the old state file and its backup

## Instructions

### 1. Authenticate with Azure
- Open your terminal or command prompt
- Run the command `az login` to authenticate with your Azure account
- Follow the instructions to sign in with your account
- After signing in, run `az account show` to ensure you are working on the correct subscription

### 2. Create a new storage account
- You can create it manually through the portal or using a new Terraform configuration (new folder, new files)
- Reference: [Create a storage account in Azure](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create)

### 3. Create a new container in the storage account
- Once the storage account is created, you will also need to create a new container for storing the state file

### 4. Configure a backend state on the newly created storage account
- Go to your providers.tf file and configure a backend state on the newly created storage account
- Here is an example of the **backend** block you should add to your code:

    ```hcl
    terraform {
    backend "azurerm" {
        resource_group_name  = "myResourceGroup"
        storage_account_name = "myStorageAccount"
        container_name       = "myContainer"
        key                  = "terraform.tfstate"
      }
    }
    ```

### 5. Move the state file to the backend
- Run `terraform init` to move the state file to the backend
- When prompted, select **yes** to copy the state file to the backend

### 6. Delete the old state file and its backup
- Now that the state file has been migrated to the backend, you can delete the local state file and its backup


## References
- [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
