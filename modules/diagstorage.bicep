param diagstorageAccountName string
param location string
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource diagstorage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: diagstorageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output diagstorageEndpoint object = diagstorage.properties.primaryEndpoints
