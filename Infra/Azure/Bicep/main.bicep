param components array
param vpc_cidr string
param subnet_mask int
param nsg array
param sshkey string
param initscript object
param vmsize string

module networkdeployment 'network.bicep' = {
  name: 'networkdeployment'
  params: {
    subnet_mask: subnet_mask
    vpc_cidr: vpc_cidr
  }
}

module lbdeployment 'loadbalancing.bicep' = {
  name: 'lbdeployment'
  params: {
    components: components
    nsg: nsg
  }
  dependsOn: [
    networkdeployment
  ]
}

module computedeployment 'compute.bicep' = {
  name: 'computedeployment'
  params: {
    sshkey: sshkey
    initscript: initscript
    vmsize: vmsize
  }
  dependsOn: [
    networkdeployment
    lbdeployment
  ]
}
