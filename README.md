# Azure Bicep based deployment of Microsoft DevBox

## Prerequisites

### Edit the parameters

Edit the ./deploy/parameters.json file to match your needs. You can set following values:

- Location of your resources
- Name of the Dev Center
- Name of one Project within the Dev Center
- IDs of users to be configured as Dev Box Users

You can look up User IDs in your Azure AD (it's the Object ID of the respective user). These users must be Azure AD members (i.e., no guest users). These users are granted Dev Box User permissions.

## Setup

### Login to Azure

```azurecli
az login
```

### Set the active Subscription

```azurecli
az account set --subscription "[YOUR_SUBSCRIPTION_NAME]"
```

### Create a Resource Group

```azurecli
az group create --name [YOUR_RESOURCE_GROUP_NAME] --location westeurope
```

### Create a Deployment

```azurecli
cd ./deploy
az deployment group create --resource-group [YOUR_RESOURCE_GROUP_NAME] --template-file main.bicep --parameters parameters.json
```

## Clean up

```azurecli
az group delete --name [YOUR_RESOURCE_GROUP_NAME] --yes
```
