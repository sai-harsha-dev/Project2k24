# Instruction to deploy templates
## These are commands for *Azure CLI*
- ARM (_supports only remote deployment_)

  ```templateFile="<raw github uri of main.json>"```
  
  ```az group create -g <reosurce-group-name> -l centralindia```
   
  ``` az deployment group create -n <deployment-group-name> -g <reosurce-group-name> --template-uri $templateFile ```


- BICEP (_supports only local deployment_)

  ```templateFile="<relative path to main.bicep>"```

  ```ParameterFile="<realtive path to parameters.json>"```
   
  ```az group create -g <reosurce-group-name> -l centralindia```
  
  ```az deployment group create -n <deployment-group-name> -g <reosurce-group-name> --template-file $templateFile --parameters $ParameterFile```

## Delete the resources
  ```az group delete -g <reosurce-group-name> -y```
