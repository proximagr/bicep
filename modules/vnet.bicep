param vnetName string
param owner string = 'pantelis'
param costCenter string = 'IT'
param location string
param addressPrefix string
param subnet0name string
param subnet0prefix string
param subnet1name string
param subnet1prefix string

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  tags:{
    Owner: owner
    CostCenter : costCenter
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
    subnets: [
      {
        name: subnet0name
        properties:{
          addressPrefix: subnet0prefix
        }
      }
      {
        name: subnet1name
        properties:{
          addressPrefix: subnet1prefix
        }
      }
    ]
  }
}

output subnetRef string = '${vnet.id}/subnets/${subnet0name}'
