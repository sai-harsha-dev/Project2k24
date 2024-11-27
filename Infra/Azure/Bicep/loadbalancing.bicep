param components array 
param nsg array

resource publiclbIp 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
    name: 'publiclbIp'
    location: resourceGroup().location
    sku: {
        name: 'Standard'
    }
    properties: {
        publicIPAddressVersion: 'IPv4'
        publicIPAllocationMethod: 'Static'
        idleTimeoutInMinutes: 4
    }

}

resource publiclb 'Microsoft.Network/loadBalancers@2024-03-01' = {
    name: 'publiclb'
    location: resourceGroup().location
    dependsOn: [
        publiclbIp
    ]
    sku: {
        name: 'Standard'
        tier: 'Regional'
    }
    properties: {
        backendAddressPools: [
            {
                name: 'webpool'
            }
        ]
        
        frontendIPConfigurations: [
            {
                name: 'externallbIP'
                properties: {
                    publicIPAddress: {
                        id: publiclbIp.id
                        location: resourceGroup().location
                    }
                }
            }
        ]

        loadBalancingRules: [
            {
                name: 'PublicInboundAccess'
                properties: {
                    backendAddressPool: {
                        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'publiclb','webpool')
                    }
                    frontendIPConfiguration: {
                        id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'publiclb','externallbIP')
                    }
                    backendPort: 8080
                    frontendPort: 8080
                    protocol: 'Tcp'
                    probe: {
                        id: resourceId('Microsoft.Network/loadBalancers/probes', 'publiclb','webprobe')
                    }
                }
            }
        ]

        probes: [
            {
                name: 'webprobe'
                properties: {
                    port: 8080
                    protocol: 'Http'
                    requestPath: '/'
                    probeThreshold: 2
                    numberOfProbes: 2
                    intervalInSeconds: 30
                }
            }
        ]

        outboundRules: [
            
        ]
    }
}


