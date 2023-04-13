# Azure Bicep based deployment of Microsoft DevBox

## Prerequisites

### Azure Bicep prerequisites

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/) before you begin.

To set up your environment for Bicep development, see [Install Bicep tools](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install). After completing those steps, you'll have [Visual Studio Code](https://code.visualstudio.com/) and the [Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep). You also have either the latest [Azure CLI](https://learn.microsoft.com/cli/azure/) or the latest [Azure PowerShell module](https://learn.microsoft.com/powershell/azure/new-azureps-module-az).

### Edit the parameters

Edit the ./deploy/parameters.json file to match your needs. You can set following values:

- Location of your resources
- Name of the Dev Center
- Name of one Project within the Dev Center
- IDs of users to be configured as Dev Box Users

You can look up User IDs in your Azure AD (it's the Object ID of the respective user). These users must be Azure AD members (i.e., no guest users). These users are granted Dev Box User permissions.

## Setup

### Login to Azure

Open a command line and login to Azure:

```azurecli
az login
```

### Set the active Subscription

Set the active subscription to the one you want to use for the deployment:

```azurecli
az account set --subscription "[YOUR_SUBSCRIPTION_NAME]"
```

### Create a Resource Group

Create a resource group for the deployment:

```azurecli
az group create --name [YOUR_RESOURCE_GROUP_NAME] --location westeurope
```

### Create a Deployment

Create a deployment using the Bicep template:

```azurecli
cd ./deploy
az deployment group create --resource-group [YOUR_RESOURCE_GROUP_NAME] --template-file main.bicep --parameters parameters.json
```

## Clean up

Delete the resource group to remove all resources:

```azurecli
az group delete --name [YOUR_RESOURCE_GROUP_NAME] --yes
```
