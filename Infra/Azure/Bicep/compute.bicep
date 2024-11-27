param sshkey string
param vmsize string = 'Standard_B1s'
param initscript object = {
  web: ''
}
param components array = [
  'web'
]

resource components_scaleset 'Microsoft.Compute/virtualMachineScaleSets@2024-07-01' = [
  for item in components: {
    name: '${item}scaleset'
    location: resourceGroup().location
    zones: [
      '1'
      '2'
    ]
    sku: {
      name: vmsize
      capacity: 2
    }
    properties: {
      orchestrationMode: 'Uniform'
      upgradePolicy: {
        mode: 'Automatic'
      }
      virtualMachineProfile: {
        networkProfile: {
          networkInterfaceConfigurations: [
            {
              name: '${item}scalesetvmnic'
              properties: {
                primary: true
                ipConfigurations: [
                  {
                    name: '${item}setip'
                    properties: {
                      loadBalancerBackendAddressPools: [
                        {
                          id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'publiclb', 'webpool')
                        }
                      ]
                      subnet: {
                        id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'Roboshop-vnet', '${item}subnet')
                      }
                    }
                  }
                ]
              }
            }
          ]
        }
        osProfile: {
          adminUsername: 'ubuntu'
          computerNamePrefix: '${item}scalesetvm'
          customData: base64(initscript[item])
          linuxConfiguration: {
            ssh: {
              publicKeys: [
                {
                  keyData: sshkey
                  path: '/home/ubuntu/.ssh/authorized_keys'
                }
              ]
            }
          }
        }
        storageProfile: {
          osDisk: {
            createOption: 'FromImage'
            diffDiskSettings: {
              option: 'Local'
            }
          }
          imageReference: {
            publisher: 'canonical'
            offer: 'ubuntu-24_04-lts'
            sku: 'server'
            version: 'latest'
          }
        }
      }
    }
  }
]

resource components_scalepolicy 'Microsoft.Insights/autoscalesettings@2022-10-01' = [
  for item in components: {
    name: '${item}scalepolicy'
    location: resourceGroup().location
    properties: {
      name: '${item}scalepolicy'
      targetResourceUri: resourceId('Microsoft.Compute/virtualMachineScaleSets', '${item}scaleset')
      enabled: true
      profiles: [
        {
          name: 'Default'
          capacity: {
            default: '2'
            maximum: '4'
            minimum: '1'
          }
          rules: [
            {
              metricTrigger: {
                metricName: 'Percentage CPU'
                metricResourceUri: resourceId('Microsoft.Compute/virtualMachineScaleSets', '${item}scaleset')
                metricResourceLocation: resourceGroup().location
                operator: 'GreaterThanOrEqual'
                statistic: 'Average'
                threshold: 60
                timeGrain: 'PT5M'
                timeWindow: 'PT10M'
                timeAggregation: 'Average'
              }
              scaleAction: {
                cooldown: 'PT15M'
                direction: 'Increase'
                type: 'ChangeCount'
                value: '1'
              }
            }
          ]
        }
      ]
    }
    dependsOn: [
      components_scaleset
    ]
  }
]
