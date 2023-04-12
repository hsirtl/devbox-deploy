@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the name of the DevCenter.')
param devcenterName string = 'democenter'

@description('Specifies the name of the project.')
param projectName string = 'my-demo-project'

param devBoxUserIds array

param devcenterNetworkConnectionName string = '${devcenterName}-netcon'


resource devcenter 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource devcenterDevBoxUserRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '45d50f46-0b78-4001-a660-4198cbe8cd05'
}

resource project 'Microsoft.DevCenter/projects@2022-11-11-preview' = {
  name: projectName
  location: location
  properties: {
    devCenterId: devcenter.id
  }
}

resource projectPool 'Microsoft.DevCenter/projects/pools@2022-11-11-preview' = {
  parent: project
  name: 'my-dev-box-pool'
  location: location
  properties: {
    devBoxDefinitionName: devboxDefinition.name
    networkConnectionName: devcenterNetworkConnectionName
    licenseType: 'Windows_Client'
    localAdministrator: 'Enabled'
  }
}

resource devboxDefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2022-11-11-preview' = {
  parent: devcenter
  name: 'win-dev-box'
  location: location
  properties: {
    imageReference: {
      id: '${resourceId('Microsoft.DevCenter/devcenters/galleries', devcenterName, 'Default')}/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    }
    sku: {
      name: 'general_a_8c32gb_v1'
    }
    osStorageType: 'ssd_512gb'
  }
}

resource projectPool_default 'Microsoft.DevCenter/projects/pools/schedules@2022-11-11-preview' = {
  parent: projectPool
  name: 'default'
  properties: {
    type: 'StopDevBox'
    frequency: 'Daily'
    time: '19:00'
    timeZone: 'Europe/Berlin'
    state: 'Enabled'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for userId in devBoxUserIds: {
  scope: project
  name: guid(project.name, userId, devcenterDevBoxUserRole.id)
  properties: {
    roleDefinitionId: devcenterDevBoxUserRole.id
    principalId: userId
    principalType: 'User'
  }
}]
