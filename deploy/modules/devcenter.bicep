@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the name of the DevCenter.')
param devcenterName string = 'democenter'


resource devcenter 'Microsoft.DevCenter/devcenters@2022-11-11-preview' = {
  name: devcenterName
  location: location
  identity: {
    type: 'None'
  }
}
