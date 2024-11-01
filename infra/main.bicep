targetScope = 'resourceGroup'

param location string = resourceGroup().location
@description('The environment designator for the deployment. Replaces {env} in namingConvention.')
@allowed([
  'dev' //Develop
  'stg' //Staging
  'prd' //Production
])
param enviromentName string = 'dev'
var enviromentResourceNameWithoutHyphen = replace(enviromentName, '-', '')

@allowed(['northeurope', 'southeastasia', 'eastasia', 'eastus2', 'southcentralus', 'australiaeast', 'eastus', 'westus2', 'uksouth', 'eastus2euap', 'westus3', 'swedencentral'])
param hostingPlanLocation string = 'eastus2'

@description('The workload name. Replaces {workloadName} in namingConvention.')
param workloadName string = 'pj'

param deploymentStorageContainerName string = 'app-pkg-func'

@description('secretName')
param secretName1 string

@secure()
@description('secretValue')
param secretValue1 string


var suffixResourceName = '-${workloadName}'
var suffixResourceNameWithoutHyphen = replace(suffixResourceName, '-', '')
var uniqueStr = uniqueString(resourceGroup().id, enviromentName, workloadName, suffixResourceNameWithoutHyphen)

param convertedEpoch int = dateTimeToEpoch(dateTimeAdd(utcNow(), 'P1Y'))

var abbrs = json(loadTextContent('abbreviations.json'))

var tags = {
  workload: workloadName
  environment: enviromentName
}

// https://learn.microsoft.com/ja-jp/dotnet/api/microsoft.azure.management.operationalinsights.models.workspacesku?view=azure-dotnet-legacy
// https://github.com/mspnp/microservices-reference-implementation/blob/e903447c7b8b6af6302a5f5a7c672572471d01e4/azuredeploy.bicep#L77
module logAnalyticsWorkspace 'modules/monitor/logAnayticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params:{
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${enviromentName}${suffixResourceName}'
    location: location
  }
}

module appInsights 'modules/monitor/appInsights.bicep' = {
  name: 'appInsights'
  params:{
    name: '${abbrs.insightsComponents}${enviromentName}${suffixResourceName}'
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
  }
}

var storageAccountName = '${abbrs.storageStorageAccounts}${enviromentResourceNameWithoutHyphen}${uniqueStr}'
module storage 'modules/storage/storage.bicep' = {
  name: 'storage'
  params: {
    storageAccountName: storageAccountName
    location: location
    tags: tags
    storageAccountType: 'Standard_LRS'
    containerNames: [deploymentStorageContainerName]
  }
}

var aspSku = {
  tier: 'Standard'
  name: 'S1'
}

module hostingPlan 'modules/host/asp.bicep' = {
  name: 'hostingPlan'
  params:{
    hostingPlanName: '${abbrs.webServerFarms}${enviromentName}${suffixResourceName}'
    location: !empty(hostingPlanLocation) ? hostingPlanLocation : location
    tags: tags
    sku: aspSku
    kind: 'functionapp,linux'
  }
}

module function 'modules/function/function.bicep' = if(aspSku.tier == 'Standard'){
  name: 'function'
  params:{
    functionName: '${abbrs.webSitesFunctions}${enviromentName}${suffixResourceName}'
    location: hostingPlanLocation
    tags: tags
    hostingPlanName: hostingPlan.outputs.name
    storageAccountName: storage.outputs.storageAccountName
    applicationInsightsName: appInsights.outputs.appInsightsName
    appInsightsInstrumentationKey: appInsights.outputs.appInsightsInstrumentationKey
    secretName1: secretName1
    secretValue1: secretValue1
  }
}
