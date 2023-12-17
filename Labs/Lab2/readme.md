# Infrastructure as Code with Terraform on Azure – Lab Guide

## Lab2 – Deploy Terraform Code
In this lab, you will learn how to create a simple Terraform configuration to deploy Azure resources. At the end of this lab, you will have a better understanding of how to use Terraform to deploy Azure resources.

## Prerequisites
Before starting this lab, ensure you have completed lab 1.

## Lab Overview
1. Authenticate to Azure with the Azure CLI
2. Create a Terraform configuration files to deploy Azure resources
3. Plan and apply your Terraform configuration

## Instructions

### 1. Authenticate with Azure
- Open your terminal or command prompt
- Run the command ```az login --tenant <tenant id>``` to authenticate with your Azure account
>**Note**: If you installed az cli while VSCode is open, you may need to restart VSCode to get the az cli to work
- Follow the instructions to sign in with your account
- After signing in, run ```az account show``` to ensure you are working on the correct subscription



### 3. Create Terraform configuration files to deploy Azure resources
- Create a new file called `main.tf`
- Write a Terraform configuration to deploy the following Azure resources:
  - Resource group
  - Virtual network
  - Subnet
  - Network interface card
  - Virtual machine

You can use the following resources to help you:

   - [Resource Group (azurerm_resource_group)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
   - [Virtual Network (vnet) (azurerm_virtual_network)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
   - [Subnet (azurerm_subnet)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
   - [Network Interface Card (azurerm_network_interface)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
  - Virtual Machine (one of the following, depending on your preference):
    - [Windows (azurerm_windows_virtual_machine)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine)
    - [Linux (azurerm_linux_virtual_machine)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

Don't forget to use variables as much as possible to make your Terraform configuration generic.