param hostingPlanName string
param location string
param tags object = {}
param functionName string
param storageAccountName string
param appInsightsInstrumentationKey string
param applicationInsightsName string
param secretName1 string
@secure()
param secretValue1 string = ''

// Get Storage Account Reference
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' existing = {
  name: hostingPlanName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

resource site 'Microsoft.Web/sites@2022-03-01' = {
  name: functionName
  kind: 'functionapp,linux'
  location: location
  tags: tags
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: secretName1
          value: secretValue1
        }
      ]
      linuxFxVersion: 'Python|3.11' //az webapp list-runtimes --linux || az functionapp list-runtimes --os linux -o table
      // ftpsState: 'FtpsOnly'
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
  }
  dependsOn:[
    appInsights
  ]
}
