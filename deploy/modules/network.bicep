@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the name of the DevCenter.')
param devcenterName string = 'democenter'

param devcenterVnetName string = '${devcenterName}-vnet'
param devcenterNetworkConnectionName string = '${devcenterName}-netcon'


resource devcenter 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource devcenterVnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: devcenterVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource devcenterNetworkConnection 'Microsoft.DevCenter/networkconnections@2022-11-11-preview' = {
  name: devcenterNetworkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: devcenterVnet.properties.subnets[0].id
  }
}

resource devcenterNetworkConnectionAttach 'Microsoft.DevCenter/devcenters/attachednetworks@2022-11-11-preview' = {
  parent: devcenter
  name: devcenterNetworkConnectionName
  properties: {
    networkConnectionId: devcenterNetworkConnection.id
  }
}
