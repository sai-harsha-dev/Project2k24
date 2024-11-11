# Instruction to deploy templates
## These are commands for *Azure CLI*
- ARM
  ```templateFile="Roboshop.json" && devParameterFile="parameters.json" && az group create --name test --location 'Central India' && az deployment group create --name devenvironment --resource-group test --template-file $templateFile --parameters $devParameterFile & az vm deallocate --resource-group test --name nginx && az vm generalize --resource-group test --name nginx &&templateFile="image.json" && az deployment group create --name devenvironment --resource-group test --template-file $templateFile ```
- BICEP
  ```templateFile="Roboshop.bicep" && devParameterFile="parameters.json" && az group create --name test --location 'Central India' && az deployment group create --name devenvironment --resource-group test --template-file $templateFile --parameters $devParameterFile & az vm deallocate --resource-group test --name nginx && az vm generalize --resource-group test --name nginx &&templateFile="image.bicep" && az deployment group create --name devenvironment --resource-group test --template-file $templateFile```
