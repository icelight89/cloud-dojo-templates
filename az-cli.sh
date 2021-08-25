#!/bin/bash

DOJO_USER=<dojo-user>
RESOURCE_GROUP=$DOJO_USER-todo-app
LOCATION=westeurope
SQL_SERVER=$DOJO_USER-todo-app-sql-server
SQL_ADMIN_PASSWORD=<sql-admin-password>
DB=todo-app-sql-db
STATIC_WEB_APP=todo-app
GIT_REPO_URL=https://github.com/<github-user>/azure-sql-db-todo-mvc.git

# Create Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION 

# Create Database Server
az sql server create --name $SQL_SERVER --location $LOCATION --resource-group $RESOURCE_GROUP --admin-user $DOJO_USER --admin-password $SQL_ADMIN_PASSWORD

# Allow Azure services and resources (in particular the Static Web App) to access the Database Server
az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $SQL_SERVER --name allow-azure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Create Database
az sql db create --name $DB --resource-group $RESOURCE_GROUP --server $SQL_SERVER --service-objective S0

# Create Static Web App
az staticwebapp create --name $STATIC_WEB_APP --location $LOCATION --resource-group $RESOURCE_GROUP --source $GIT_REPO_URL --branch main --app-location '/client' --api-location '/api' --login-with-github

# Set function app settings of the Static Web App required to access the Database
az rest --method put --headers "Content-Type=application/json" --uri "/subscriptions/ffd96b6f-1fcb-4bb8-b0ad-b151d795064a/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Web/staticSites/$STATIC_WEB_APP/config/functionappsettings?api-version=2019-12-01-preview" --body @local.settings.properties.json

# Clean up
#az group delete --name $RESOURCE_GROUP
