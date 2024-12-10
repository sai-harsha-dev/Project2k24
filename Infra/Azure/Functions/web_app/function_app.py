import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
import time
import logging

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.function_name(name='webupdate')
@app.route(route="webupdate")
def web_update(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    try:
        req_body = req.get_json()
    except ValueError:
        return func.HttpResponse("Invalid JSON in request body", status_code=400)

    creds = DefaultAzureCredential()
    sub_id = req_body.get("sub_id")
    resource_group_name = req_body.get("rg_name")
    vmss_name = req_body.get("vmss_name")

    vmss_info = ComputeManagementClient(creds, sub_id)

    webvmss_vm_ids = vmss_info.virtual_machine_scale_set_vms.list(resource_group_name, vmss_name)

    vm_count = vmss_info.virtual_machine_scale_sets.get (resource_group_name, vmss_name).sku.capacity

    for vm in webvmss_vm_ids:

        try:

            logging.info(f"Deleting VM instance with ID: {vm.instance_id}")

            vm_restart = vmss_info.virtual_machine_scale_set_vms.begin_delete(resource_group_name, vmss_name, vm.instance_id )
        
        except Exception as error:
            
            return func.HttpResponse(f"Stop operation failed \n ERROR: {error}",status_code=200)

        try: 

            while vmss_info.virtual_machine_scale_sets.get (resource_group_name, vmss_name).sku.capacity < vm_count:

                logging.info(f"Waiting for new instance to reprenish")
                time.sleep(20)

        except:

            return func.HttpResponse("Error occured during new vm creation",status_code=200)


    return func.HttpResponse("VM Update completed", status_code=200)