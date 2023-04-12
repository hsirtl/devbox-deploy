# Azure Bicep based deployment of Microsoft DevBox

## Edit the parameters

Edit the parameters.json file to match your needs. You can set following values:

- Location of your resources
- Name of the Dev Center
- Name of one Project within the Dev Center
- IDs of users to be configured as Dev Box Users

## Login to Azure

```azurecli
az login
```

# Set the active Subscription

```azurecli
az account set --subscription "[YOUR_SUBSCRIPTION_NAME]"
```

# Create a Resource Group

```azurecli
az group create --name [YOUR_RESOURCE_GROUP_NAME] --location westeurope
```

# Create a Deployment

```azurecli
cd ./deploy
az deployment group create --resource-group [YOUR_RESOURCE_GROUP_NAME] --template-file main.bicep --parameters parameters.json
```

# Clean up

```azurecli
az group delete --name [YOUR_RESOURCE_GROUP_NAME] --yes
```
