param vm_size string = 'Standard_B1s'
param sshkey string 
param initscript string

resource robovnet 'Microsoft.Network/virtualNetworks@2024-03-01' ={
  name: 'RoboVnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name:'robosubnet'
        properties: {
          addressPrefix:'10.0.0.0/24'
        }
      }
    ]
  }
}
resource ubuntuVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'nginx'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vm_size
    }
    osProfile: {
      computerName: 'Frontend'
      adminUsername: 'ubuntu'
      customData: base64(initscript)
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
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [
        {
          name:'Robonic'
          properties: {
            deleteOption: 'Delete'
            ipConfigurations:  [
              { 
                name: 'RoboIP'
                properties: {
                  subnet: {
                    id: robovnet.properties.subnets[0].id
                  }
                  privateIPAddressVersion: 'IPv4'
                  publicIPAddressConfiguration: {
                    name: 'pubip'
                    properties: {
                      publicIPAddressVersion: 'IPv4'
                      publicIPAllocationMethod: 'Static'
                      deleteOption: 'Delete'
                    }
                  }
                }
              }
            ]
          }}
      ]
    }
  }
}

