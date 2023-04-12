@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the name of the DevCenter.')
param devcenterName string = 'democenter'

@description('Specifies the name of the project.')
param projectName string = 'my-demo-project'

@description('Specifies the user ids of the DevBox users.')
param devBoxUserIds array

var devcenterVnetName = '${devcenterName}-vnet'
var devcenterNetworkConnectionName = '${devcenterName}-netcon'


// Step 1: Create DevCenter
module devcenter './modules/devcenter.bicep' = {
  name: 'devcenter'
  params: {
    location: location
    devcenterName: devcenterName
  }
}

// Step 2: Create DevCenter Network Connection
module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    devcenterName: devcenterName
    devcenterVnetName: devcenterVnetName
    devcenterNetworkConnectionName: devcenterNetworkConnectionName
  }
  dependsOn: [
    devcenter
  ]
}

// Step 3: Create DevCenter Project
module project './modules/project.bicep' = {
  name: 'project'
  params: {
    location: location
    devcenterName: devcenterName
    devcenterNetworkConnectionName: devcenterNetworkConnectionName
    projectName: projectName
    devBoxUserIds: devBoxUserIds
  }
  dependsOn: [
    network
  ]
}
