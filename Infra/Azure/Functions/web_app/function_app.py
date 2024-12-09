import azure.functions as func
import logging 
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
import time

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.function_name(name='web_update')
@app.route(route="webupdate")
def web_update(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    req_body = req.get_json()

    creds = DefaultAzureCredential()
    sub_id = req_body.get("sub_id")
    resource_group_name = req_body.get("rg_name")
    vmss_name = req_body.get("vmss_name")

    vmss_info = ComputeManagementClient(creds, sub_id)

    webvmss_vm_ids = vmss_info.virtual_machine_scale_set_vms.list(resource_group_name, vmss_name)

    for ids in webvmss_vm_ids:

        try:

            logging.info(f"Restarting VM instance with ID: {ids}")

            vm_restart = vmss_info.virtual_machine_scale_set_vms.restart(resource_group_name, vmss_name, ids)
        
        except HttpResponseError :

            logging.info(f"Stop operation failed \n ERROR: {vm_restart}")

        try: 

            while vmss_info.virtual_machine_scale_set_vms.list(resource_group_name, vmss_name) <= len(webvmss_vm_ids):

                logging.info(f"Waiting for new instance to reprenish")
                time.sleep(5)

        except:

            logging.info("Error occured during new vm creation")


    return func.HttpResponse("VM Update completed", status_code=200)



 