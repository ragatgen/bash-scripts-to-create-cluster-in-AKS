#!/bin/bash

# Prompt the user for the AKS cluster name, resource group, and subscription
read -p "Enter the name of your AKS cluster: " AKS_CLUSTER_NAME
read -p "Enter the name of the resource group for your AKS cluster: " RESOURCE_GROUP
read -p "Enter the name or ID of the subscription containing your AKS cluster: " SUBSCRIPTION

# Set the subscription context for the Azure CLI
az account set --subscription $SUBSCRIPTION

# Get the current version of your AKS cluster
CURRENT_VERSION=$(az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query 'kubernetesVersion' -o tsv)

# Get the latest version available for AKS
LATEST_VERSION=$(az aks get-versions --location eastus --query 'orchestrators[-1].orchestratorVersion' -o tsv)

# Upgrade the AKS cluster to the latest version
az aks upgrade --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --kubernetes-version $LATEST_VERSION

# Verify that the upgrade was successful
NEW_VERSION=$(az aks show --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query 'kubernetesVersion' -o tsv)

if [ "$NEW_VERSION" == "$LATEST_VERSION" ]; then
  echo "AKS cluster upgraded to version $NEW_VERSION"
else
  echo "AKS cluster upgrade failed"
fi
