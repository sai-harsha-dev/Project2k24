resource nginx_img 'Microsoft.Compute/images@2024-07-01' = {
  name: 'Nginx_Image'
  location: resourceGroup().location
  properties: {
    sourceVirtualMachine: {
      id: resourceId('Microsoft.Compute/virtualMachines','nginx')
    }
  }
}
