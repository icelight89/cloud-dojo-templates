# Azure Resource Manager templates

These ARM templates help with setting up the required cloud resources to run the [TodoMVC Sample App Full Stack Implementation](https://github.com/Azure-Samples/azure-sql-db-todo-mvc)
### How to use

1. Go to the `clouddojosubdeployment.parameters.json` file and add your unique acronym as a prefix to the resource group.

1. Go to the `clouddojodeployment.parameters.json` and replace the tokens for the server admin username, the server admin password, the Github repository url and the repository token to access your GH repository.

1. First we need to create an resource group for our resources. To do that run 
    ``` Azure CLI
    az deployment sub create \
    --name cloudDojoSubDeployment \
    --location westeurope \
    --template-file ./clouddojosubdeployment.json  \
    --parameters ./clouddojosubdeployment.parameters.json
    ```
1. Next are the cloud resources themselves. Replace the placeholder tokens with your values and run the following command from this folder:
    ``` Azure CLI
    az deployment group create \
    --resource-group <YOUR RESOURCE GROUP> \
    --template-file ./clouddojodeployment.json \
    --parameters ./clouddojodeployment.parameters.json
    ```
1. While waiting for the deployment to finish, go to the `local.settings.properties.json` file and fill in the name for your SQL-Server instance. This should look something like this `<YOUR RESOURCE GROUP NAME>-sql`

1. Then fill in the values for your Static Web App instance and run the following command from this folder:
    ``` Azure CLI
    az rest \
    --method put \
    --headers "Content-Type=application/json" \
    --uri "/subscriptions/<YOUR_SUBSCRIPTION_ID>/resourceGroups/<YOUR_RESOURCE_GROUP_NAME>/providers/Microsoft.Web/staticSites/<YOUR_STATIC_SITE_NAME>/config/functionappsettings?api-version=2019-12-01-preview" \
    --body @../local.settings.properties.json
    ```

1. Now we have to initialize the database. 
    1. Go to the Azure SQL databse resource in the [Azure Portal](https://portal.azure.com)
    1. In the Overview select "Set server firewall" in the ribbon below the resource name.
    1. There select "Add client IP" and then press the save button. 
    1. Now you should be able to connect the the database from your local machine with your tool of choice. We will use the Query Editor from the Browser. Go back to your SQL Database resource.
    1. Select "Query editor (preview)" from the right navigation menu.
    1. Login with the server admin account you specfied in the parameters file.
    1. Copy the content of the [create.sql](https://github.com/Azure-Samples/azure-sql-db-todo-mvc/blob/main/database/create.sql) file from the sample repository, paste it into the editor and then run the query.
    1. Your database should now be ready for usage.

1. Go to your Static Web App resource and in the "Overview" blade open the "URL" to your website.
