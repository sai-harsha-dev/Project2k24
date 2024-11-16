# Instructions to Deploy the stack.
## Pre-requsists
- Install and Configure AWS CLI, follow below commands
  - Windows

    Download and install the MSI from --> _https://awscli.amazonaws.com/AWSCLIV2.msi_
    
  - Linux

    ```curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" ```

    ```unzip awscliv2.zip```

    ```sudo ./aws/install```

- Configure IAM user credentials 
    - Run the following command and input the ACCESS, SECRET_ACCESS key when prompted

       ```aws configure``` 

## Deploy stack 
_NOTE :- only deploy in the same order, to ensure export depencdencies are satisfied_
   - ```aws cloudformation deploy --stack-name {Name_for_the_stack} --template {relative_path_to_Network.yml}```

   - ```aws cloudformation deploy --stack-name {Name_for_the_stack} --template {relative_path_to_Loadbalacing.yml}```

   - ```aws cloudformation deploy --stack-name {Name_for_the_stack} --template {relative_path_to_Instance.yml}```


## Delete Stack
_NOTE :- only delete in the same order, to ensure export depencdencies are satisfied_

  - ``` aws cloudformation delete-stack --stack-name {Network_stackname} && aws cloudformation wait stack-delete-complete --stack-name {Network_stackname} ```

  - ``` aws cloudformation delete-stack --stack-name {Loadbalancing_stackname} && aws cloudformation wait stack-delete-complete --stack-name {Loadbalancing_stackname} ```

  - ``` aws cloudformation delete-stack --stack-name {Instance_stackname} && aws cloudformation wait stack-delete-complete --stack-name {Instance_stackname} ```



