param vpc_cidr string = '172.16.0.0/16'
param subnet_mask int = 24
param components array = [
  'web'
]

resource Roboshop_vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: 'Roboshop-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vpc_cidr
      ]
    }
  }
}

resource components_nsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = [
  for item in components: {
    name: '${item}nsg'
    location: resourceGroup().location
    properties: {
      securityRules: [
        {
          name: 'internrule'
          properties: {
            access: 'Allow'
            destinationAddressPrefix: '0.0.0.0/0'
            destinationPortRange: '*'
            sourceAddressPrefix: '*'
            sourcePortRange: '*'
            direction: 'Outbound'
            priority: 101
            protocol: '*'
          }
        }
        {
          name: 'pubicinboundrule'
          properties: {
            access: 'Allow'
            sourceAddressPrefix: ((item == 'web') ? '0.0.0.0/0' : vpc_cidr)
            destinationAddressPrefix: '*'
            destinationPortRange: '*'
            sourcePortRange: '*'
            direction: 'Inbound'
            priority: 101
            protocol: '*'
          }
        }
      ]
    }
  }
]

resource Roboshop_vnet_components_subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = [
  for (item, i) in components: {
    parent: Roboshop_vnet
    name: '${item}subnet'
    properties: {
      addressPrefix: cidrSubnet(vpc_cidr, subnet_mask, (i + 1))
      defaultOutboundAccess: false
      networkSecurityGroup: {
        id: resourceId('Microsoft.Network/networkSecurityGroups', '${item}nsg')
      }
    }
    dependsOn: [
      components_nsg
    ]
  }
]
