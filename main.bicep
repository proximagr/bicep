@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param location string = resourceGroup().location
param addressPrefix string = '10.0.0.0/16'
param subnet0name string = 'sub1'
param subnet0prefix string = '10.0.0.0/24'
param subnet1name string = 'sub2'
param subnet1prefix string = '10.0.1.0/24'
param adminPassword string
param adminUserName string
param nicName string = 'pnic${uniqueString(resourceGroup().id)}'
param publicIPAddressName string = 'pip${uniqueString(resourceGroup().id)}'
param vnetName string = 'pvnet${uniqueString(resourceGroup().id)}'
param vmName string = 'myvmname'
param storageAccountName string = 'proxgr${uniqueString(resourceGroup().id)}'
param diagstorageAccountName string = 'diag${uniqueString(resourceGroup().id)}'

@allowed([
  '2008-R2-SP1'
  '2012-Datacenter'
  '2012-R2-Datacenter'
  '2016-Nano-Server'
  '2016-Datacenter-with-Containers'
  '2016-Datacenter'
  '2019-Datacenter'
])
@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param windowsOSVersion string

@allowed([
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
])
@description('Size of the virtual machine.')
param vmSize string

@allowed([
  32
  64
  128
])
param disksize int

module diagstorage 'modules/diagstorage.bicep' = {
  name: 'diagstoragedeploy'
  params: {
    location: location
    environmentType: environmentType
    diagstorageAccountName: diagstorageAccountName
  }
}

module storageAccount 'modules/create-storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    environmentType: environmentType
    storageAccountName: storageAccountName
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    environmentType: environmentType
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnet0name: subnet0name
    subnet0prefix: subnet0prefix
    subnet1name: subnet1name
    subnet1prefix: subnet1prefix
  }
}

module vm2019 'modules/vm.bicep' = {
  name: 'vm2019'
  params: {
    adminPassword: adminPassword
    adminUserName: adminUserName
    disksize: disksize
    location: location
    nicName: nicName
    publicIPAddressName: publicIPAddressName
    vmSize: vmSize
    windowsOSVersion: windowsOSVersion
    vmName: vmName
    diagstorageEndpoint: diagstorage.outputs.diagstorageEndpoint
    subnetRef: vnet.outputs.subnetRef
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
