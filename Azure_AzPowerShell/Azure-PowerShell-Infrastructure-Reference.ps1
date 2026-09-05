# AZURE POWERSHELL — ESSENTIAL INFRASTRUCTURE REFERENCE
# Basic → Intermediate → Advanced
# Mental model:
# Tenant / Microsoft Entra ID
# └── Management Group
# └── Subscription
# └── Resource Group
# └── Resources

#

# RBAC (Role-Based Access Control) → Principal + Role + Scope
# Policy → What is allowed / required
# ARM (Azure Resource Manager) → Management Layer → Azure Resources
# Region → Geographic Location
# Tags → Resource Metadata


# 01. AZURE POWERSHELL FUNDAMENTALS

# Check PowerShell version
$PSVersionTable.PSVersion

# Check installed Az modules
Get-Module -Name Az -ListAvailable

# Discover Azure cmdlets
Get-Command -Module Az.*

# Get cmdlet help and examples
Get-Help Get-AzVM
Get-Help New-AzVM -Examples

# Inspect properties and methods returned by Azure cmdlets
Get-AzResource | Get-Member

# 02. AUTHENTICATION / CONTEXT

# Authenticate to Azure
Connect-AzAccount

# View current tenant, account and subscription context
Get-AzContext

# List subscriptions available to the authenticated identity
Get-AzSubscription

# Switch the active subscription
Set-AzContext -Subscription "<subscription-name>"

# List saved Azure contexts
Get-AzContext -ListAvailable

# Authenticate using a managed identity
Connect-AzAccount -Identity


# 03. IDENTITY

# Discover Microsoft Entra ID service principals
Get-AzADServicePrincipal

# Create a service principal
New-AzADServicePrincipal -DisplayName "sp-example"

# Identity types:
# User → human identity
# Service Principal → application identity
# Managed Identity → Azure-managed application identity
#
# App Registration → defines the application
# Service Principal → tenant-specific identity representing that application
#
# Never hardcode secrets in scripts.


# 04. RBAC

# RBAC = Role-Based Access Control
# Authentication → Who are you?
# Authorization → What are you allowed to do?
#
# RBAC = Principal + Role + Scope
# Scope = Management Group / Subscription / Resource Group / Resource
# View role assignments

Get-AzRoleAssignment

# Assign an Azure RBAC role
New-AzRoleAssignment -ObjectId "<object-id>" -RoleDefinitionName "Reader" -Scope "<scope>"

# Remove an Azure RBAC role
Remove-AzRoleAssignment -ObjectId "<object-id>" -RoleDefinitionName "Reader" -Scope "<scope>"

# Common roles:
# Reader → view
# Contributor → manage resources
# Owner → manage resources and access
#
# Production principle:
# Least privilege.


# 05. RESOURCE GROUPS

# List Resource Groups
Get-AzResourceGroup

# Create a Resource Group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tags

# Resource Group = logical management container.
# Used for organization, lifecycle, RBAC, tags, deployments and cleanup.


# 06. REGION / LOCATION

# Discover Azure regions and their location identifiers
Get-AzLocation | Select-Object DisplayName, Location

# Region → geographic Azure area
# Location → identifier used by Azure cmdlets
# Example:
# East US → eastus
#
# Select regions based on latency, availability, compliance,
# data residency, service availability and cost.


# 07. RESOURCE PROVIDERS

# Discover Azure Resource Providers
Get-AzResourceProvider

# Inspect a specific provider
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute

# Register a provider when required
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute

# Common providers:
# Microsoft.Compute
# Microsoft.Network
# Microsoft.Storage
# Microsoft.KeyVault
# Microsoft.Web
# Microsoft.Sql


# 08. TAGS

$Tags = @{
Environment = "Lab"
Application = "ReferenceApp"
Owner       = "IT"
ManagedBy   = "PowerShell"
}

# Update resource tags
Update-AzTag -ResourceId "<resource-id>" -Tag $Tags -Operation Merge

# Tags are metadata used for organization, ownership,
# automation, cost management and governance.


# 09. RESOURCE DISCOVERY

# List all Azure resources
Get-AzResource

# List resources inside a Resource Group
Get-AzResource -ResourceGroupName $ResourceGroupName

# Filter resources by type
Get-AzResource | Where-Object ResourceType -eq "Microsoft.Compute/virtualMachines"

# Select useful properties
Get-AzResource | Select-Object Name, ResourceGroupName, Location, ResourceType

# Pipeline pattern:
# Get → Where → Select → Format / Export


# 10. OUTPUT / OBJECT PROCESSING

# Display resources as a table
Get-AzResource | Format-Table

# Display resources as a list
Get-AzResource | Format-List

# Convert Azure objects to JSON
Get-AzResource | ConvertTo-Json -Depth 10

# Export objects as CSV
Get-AzResource | ConvertTo-Csv

# PowerShell works with objects, not only text.


# 11. ARM RESOURCE IDs

# Display resource IDs
Get-AzResource | Select-Object Name, ResourceId

# Resource ID structure:
# /subscriptions/<subscription>
# /resourceGroups/<resource-group>
# /providers/<provider>
# /<resource-type>/<resource-name>


# 12. STORAGE

# Discover storage accounts
Get-AzStorageAccount

# Create a Storage Account
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -SkuName Standard_LRS -Kind StorageV2 -Tag $Tags

# StorageV2 → general-purpose v2
# Standard_LRS → locally redundant storage
# Storage supports Blob, File, Queue and Table.


# 13. NETWORKING

# Create a subnet configuration
$Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix "10.10.1.0/24"

# Create a Virtual Network
New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VNetName -AddressPrefix "10.10.0.0/16" -Subnet $Subnet

# Core network model:
# VNet → Subnet → NIC → VM
#
# Additional networking:
# NSG (Network Security Group), Firewall, Private Endpoint, Load Balancer,
# Application Gateway, VPN, ExpressRoute.


# 14. NETWORK SECURITY GROUP

# Create an NSG
New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name $NSGName

# NSG rules define:
# Source + Destination + Port + Protocol +
# Direction + Allow/Deny + Priority
#
# Avoid exposing RDP (Remote Desktop Protocol) / SSH (Secure Shell) directly to the Internet.


# 15. PUBLIC IP

# Create a public IP
New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location -Name $PublicIPName -AllocationMethod Static -Sku Standard

# Public IP = Internet-facing connectivity.
# Prefer private connectivity when public exposure is unnecessary.


# 16. COMPUTE / VM

# List virtual machines
Get-AzVM

# List VM runtime status
Get-AzVM -Status

# Typical VM architecture:
# VM → NIC → Subnet → VNet
# VM → OS Disk / Data Disk
# VM → Managed Identity
#
# Administration should preferably use:
# Bastion, VPN, private connectivity or restricted access.


# 17. MANAGED IDENTITY

# Create a user-assigned managed identity
New-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name "id-reference-app"

# Assign permissions to the identity
New-AzRoleAssignment -ObjectId "<identity-object-id>" -RoleDefinitionName "Reader" -Scope "<resource-id>"

# Mental model:
# Azure Resource → Managed Identity → Entra ID → RBAC (Role-Based Access Control) → Azure Resource


# 18. KEY VAULT

# Create a Key Vault
New-AzKeyVault -Name "kv-reference-12345" -ResourceGroupName $ResourceGroupName -Location $Location

# Key Vault protects:
# Secrets + Keys + Certificates
#
# Prefer:
# Application → Managed Identity → Key Vault
#
# Avoid passwords and connection strings in source code.


# 19. AZURE POLICY

# Discover policy definitions
Get-AzPolicyDefinition

# Discover policy assignments
Get-AzPolicyAssignment

# RBAC → Who can perform an action?
# Policy → What configuration/action is allowed or required?
#
# Examples:
# Approved regions
# Required tags
# Encryption requirements
# Deny public IPs
# Allowed resource types


# 20. RESOURCE LOCKS

# Discover locks
Get-AzResourceLock

# Create a deletion-protection lock
New-AzResourceLock -LockName "protect-resource" -LockLevel CanNotDelete -LockNotes "Protect production resource" -ResourceGroupName $ResourceGroupName

# Remove a lock
Remove-AzResourceLock -LockName "protect-resource"

# Lock types:
# CanNotDelete
# ReadOnly


# 21. APP SERVICE

# Discover App Service commands
Get-Command -Module Az.Websites

# Create an App Service Plan
New-AzAppServicePlan -Name "asp-reference" -Location $Location -ResourceGroupName $ResourceGroupName -Tier Basic -WorkerSize Small

# Create a Web App

New-AzWebApp -Name "app-reference-12345" -Location $Location -AppServicePlan "asp-reference" -ResourceGroupName $ResourceGroupName

# Important concepts:
# Plan + Web App + Slots + TLS + Custom Domain +
# Scaling + Private Endpoint + Application Insights.

# 22. AZURE SQL

# Discover SQL commands
Get-Command -Module Az.Sql

# Create SQL Server
New-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName "sql-reference-12345" -Location $Location -SqlAdministratorCredentials $Credential

# Create SQL Database
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName "sql-reference-12345" -DatabaseName "AppDB"

# Production concerns:
# Authentication + Firewall + Private Endpoint +
# Backup + Geo-replication + Failover + Scaling + Monitoring.


# 23. COSMOS DB

# Discover Cosmos DB commands
Get-Command -Module Az.CosmosDB

# Discover Cosmos DB creation commands
Get-Command New-AzCosmosDB*

# Mental model:
# Account → Database → Container → Documents
#
# Important:
# Partition Key + Throughput + Consistency +
# Global Distribution + Networking + Backup.


# 24. ARM / BICEP DEPLOYMENT


# Deploy an ARM/Bicep template to a Resource Group
New-AzResourceGroupDeployment -Name "deployment-reference" -ResourceGroupName $ResourceGroupName -TemplateFile ".\main.bicep"

# PowerShell → imperative (you specify step-by-step how Azure should be changed)
# Bicep → declarative (you specify the desired final state; Azure determines how to create/update it)
#
# Bicep is generally preferred for new Azure IaC (Infrastructure as Code)
# because it is concise, Azure-native, strongly typed, supports reusable modules,
# and is easier to maintain than raw ARM (Azure Resource Manager) JSON templates.

# 25. WHAT-IF

# Preview infrastructure changes before deployment
New-AzResourceGroupDeployment -Name "deployment-preview" -ResourceGroupName $ResourceGroupName -TemplateFile ".\main.bicep" -WhatIf

# Pattern:
# Template → What-If → Review → Deploy


# 26. DEPLOYMENT SCOPES

# Resource Group deployment
New-AzResourceGroupDeployment

# Subscription deployment
New-AzSubscriptionDeployment

# Management Group deployment
New-AzManagementGroupDeployment

# Tenant deployment
New-AzTenantDeployment

# Choose the deployment scope that matches the resources being managed.


# 27. TEMPLATE PARAMETERS

# Pass parameters directly to a deployment
$Parameters = @{
location    = $Location
environment = "dev"
}

New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile ".\main.bicep" -TemplateParameterObject $Parameters

# Parameters make infrastructure reusable across environments.


# 28. TEMPLATE SPECS

# Discover Template Specs
Get-AzTemplateSpec

# Create a Template Spec
New-AzTemplateSpec

# Template Specs provide centrally stored reusable infrastructure definitions.


# 29. DIRECT ARM REST

# Call ARM REST API when an Az cmdlet is unavailable
Invoke-AzRestMethod -Method GET -Path "<resource-id>?api-version=<api-version>"

# REST:
# GET → retrieve
# PUT → create/replace
# PATCH → partial update
# DELETE → remove
#
# Requires:

# Resource ID + HTTP method + API version + body when required.


# 30. ASYNCHRONOUS OPERATIONS

# Start an Azure operation as a PowerShell job
$Job = Get-AzVM -Status -AsJob

# View running jobs
Get-Job

# Retrieve job results
Receive-Job -Id $Job.Id

# Always verify the actual Azure state after asynchronous operations.


# 31. AZURE POWERSHELL CONFIGURATION

# View Az configuration
Get-AzConfig

# Modify Az configuration
Update-AzConfig -DisplayBreakingChangeWarning $true

# Configuration includes defaults, warnings, login behavior and other Az settings.


# 32. CONTEXT MANAGEMENT

# List contexts
Get-AzContext -ListAvailable

# Select a context
Select-AzContext

# Save a context
Save-AzContext

# Import a context
Import-AzContext

# Clear a context
Clear-AzContext

# Disconnect Azure account
Disconnect-AzAccount

# Context management is important when working with multiple subscriptions.


# 33. RESOURCE LIFECYCLE

# Discover current Azure state
Get-AzResource

# Delete an individual resource
Remove-AzResource -ResourceId "<resource-id>"

# Delete a Resource Group and its resources
Remove-AzResourceGroup -Name $ResourceGroupName

# Preview destructive changes where supported
Remove-AzResourceGroup -Name $ResourceGroupName -WhatIf

# Lifecycle:
# Plan → Authenticate → Select Subscription → Deploy →
# Configure → Monitor → Validate → Update → Retire


# 34. MOVE RESOURCES

# Move supported resources between Resource Groups or subscriptions
Move-AzResource -ResourceId "<resource-id>" -DestinationSubscriptionId "<subscription-id>" -DestinationResourceGroupName "<resource-group>"

# Not every resource supports movement.
# Dependencies must be checked.


# 35. MONITORING / OPERATIONS

# Production requires more than resource creation.
#
# Monitor:
# Azure Monitor
# Log Analytics
# Metrics
# Alerts
# Activity Logs
# Application Insights
# Backup
# Defender for Cloud
# Cost Management
#
# Operational model:
# Deploy → Observe → Detect → Alert → Respond


# 36. PRODUCTION SECURITY MODEL

# Identity:
# Entra ID → RBAC (Role-Based Access Control) → Managed Identity
#
# Network:
# VNet (Virtual Network) → Subnet → NSG (Network Security Group) → Private Endpoint
#
# Data:
# Encryption → Key Vault → Backup
#
# Governance:
# Management Groups → Policy → Tags → Cost Management
#
# Operations:
# Monitor → Logs → Alerts → Automation


# 37. SAFE AZURE SESSION

# Authenticate
Connect-AzAccount

# Check current context
Get-AzContext

# List subscriptions
Get-AzSubscription

# Select subscription
Set-AzContext -Subscription "<subscription-name>"

# Verify again
Get-AzContext


# 38. DEPLOYMENT VARIABLES

$Environment = "Lab"
$Application = "ReferenceApp"
$Owner = "IT"
$ManagedBy = "PowerShell"

$ResourceGroupName = "rg-$Environment-$Application".ToLower()
$Location = "eastus"

$Tags = @{
Environment = $Environment
Application = $Application
Owner       = $Owner
ManagedBy   = $ManagedBy
}


# 39. OPTIONAL LAB DEPLOYMENT

$RunDeployment = $false

if ($RunDeployment) {

# Check whether the Resource Group already exists
$ExistingRG = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

# Create the Resource Group when it does not exist
if (-not $ExistingRG) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tags
}

# Verify the Resource Group
Get-AzResourceGroup -Name $ResourceGroupName

}


# 40. VALIDATION

# Verify actual Azure resources after deployment
Get-AzResource -ResourceGroupName $ResourceGroupName

# Validate service-specific state
Get-AzVM
Get-AzVirtualNetwork
Get-AzNetworkSecurityGroup
Get-AzStorageAccount
Get-AzWebApp
Get-AzSqlServer
Get-AzKeyVault

# Mindset:
# Desired State → Deployment → Actual Azure State → Compare


# 41. PRODUCTION DEPLOYMENT CHECKLIST
# Tenant
# Subscription
# Region
# Resource Group
# Naming
# Tags
# Network
# IP ranges
# NSG rules
# Public exposure
# Identity
# RBAC
# Policy
# Encryption
# Key Vault
# Backup
# Monitoring
# Logging
# Alerts
# Disaster Recovery
# Availability
# Cost
# Deployment method
# What-If
# Validation
# Retirement


# 42. AZURE DEPLOYMENT PATTERN TO MEMORIZE

# WHO?
# Tenant / Identity / Service Principal / Managed Identity
#
# WHERE?
# Subscription / Region / Resource Group
#
# WHAT?
# VM / App Service / Storage / SQL / etc.
#
# NETWORK?
# VNet (Virtual Network) / Subnet / NSG (Network Security Group) / Private or Public Connectivity
#
# ACCESS?
# RBAC (Role-Based Access Control) / Least Privilege
#
# SECURITY?
# Policy / Key Vault / Encryption / Defender
#
# DEPLOYMENT?
# PowerShell / Bicep / ARM (Azure Resource Manager) / CI-CD (Continuous Integration / Continuous Delivery)
#
# OPERATIONS?
# Monitor / Logs / Alerts / Backup
#
# VALIDATION?
# Get-* / What-If / Health Checks
#
# LIFECYCLE?
# Update / Scale / Backup / DR (Disaster Recovery) / Delete


# 43. CORE COMMAND CHEAT SHEET

# Authentication
Connect-AzAccount
Get-AzContext
Set-AzContext
Get-AzSubscription

# Discovery
Get-AzResource
Get-AzResourceGroup
Get-AzLocation
Get-AzResourceProvider
Get-Command -Module Az.*

# Organization
New-AzResourceGroup
Update-AzTag
New-AzResourceLock

# RBAC (Role-Based Access Control)
Get-AzRoleAssignment
New-AzRoleAssignment
Remove-AzRoleAssignment

# Network
New-AzVirtualNetworkSubnetConfig
New-AzVirtualNetwork
New-AzNetworkSecurityGroup
New-AzPublicIpAddress
New-AzNetworkInterface

# Compute
New-AzVM
Get-AzVM
Remove-AzVM

# Storage
New-AzStorageAccount
Get-AzStorageAccount
Remove-AzStorageAccount

# Security
New-AzKeyVault
New-AzUserAssignedIdentity
Get-AzPolicyAssignment

# Application
New-AzAppServicePlan
New-AzWebApp

# Database
New-AzSqlServer
New-AzSqlDatabase
New-AzCosmosDBAccount

# Deployment
New-AzResourceGroupDeployment
New-AzSubscriptionDeployment
New-AzManagementGroupDeployment
New-AzTenantDeployment

# REST (Representational State Transfer)
Invoke-AzRestMethod

# Lifecycle
Move-AzResource
Remove-AzResource
Remove-AzResourceGroup

# Configuration
Get-AzConfig
Update-AzConfig


# 44. FINAL MENTAL MODEL

# PowerShell
# ↓
# Az PowerShell Cmdlet
# ↓
# ARM (Azure Resource Manager)
# ↓
# Resource Provider
# ↓
# Azure Resource
#
# Organization:
# Tenant (Microsoft Entra ID Directory)
# ↓
# Management Group
# ↓
# Subscription
# ↓
# Resource Group
# ↓
# Resource
#
# Security:
# Principal + Role + Scope
# ↓
# RBAC (Role-Based Access Control)
#
# Infrastructure:
# Region
# ↓
# Network
# ↓
# Identity
# ↓
# Security
# ↓
# Compute / Application / Data
# ↓
# Monitoring / Backup / Operations

# END — AZURE POWERSHELL ESSENTIAL INFRASTRUCTURE REFERENCE


# ---


# Azure PowerShell Cmdlets to Know for Infrastructure Deployment

# Core Deployment and Management Cmdlets

# Connect-AzAccount — authenticate
# Get-AzContext — see current tenant/subscription context
# Set-AzContext — switch subscription/context
# Get-AzSubscription — discover subscriptions
# Get-AzResourceGroup — discover resource groups
# New-AzResourceGroup — create a resource group
# Get-AzResource — discover resources
# New-AzResource — create generic resources when needed
# Remove-AzResource — delete a resource
# Remove-AzResourceGroup — delete an entire environment
# Get-AzLocation — discover Azure regions/locations
# Get-AzResourceProvider — understand available resource providers
# Get-AzRoleAssignment — inspect RBAC permissions
# New-AzRoleAssignment — assign permissions
# New-AzVirtualNetwork — create a VNet
# New-AzVirtualNetworkSubnetConfig — define a subnet
# New-AzNetworkSecurityGroup — create network security
# New-AzNetworkInterface — create a VM's network interface
# New-AzVM — deploy a virtual machine
# New-AzStorageAccount — deploy a fundamental data resource


# Infrastructure Discovery and Monitoring Cmdlets

# Get-AzVM — discover virtual machines
# Get-AzVM -Status — discover VM power/runtime status
# Get-AzVirtualNetwork — discover VNets
# Get-AzVirtualNetworkSubnetConfig — inspect VNet subnets
# Get-AzNetworkSecurityGroup — discover NSGs
# Get-AzNetworkInterface — discover NICs
# Get-AzPublicIpAddress — discover public IPs
# Get-AzRouteTable — discover route tables
# Get-AzStorageAccount — discover storage accounts
# Get-AzSqlServer — discover Azure SQL servers
# Get-AzSqlDatabase — discover Azure SQL databases
# Get-AzCosmosDBAccount — discover Cosmos DB accounts
# Get-AzKeyVault — discover Key Vaults
# Get-AzWebApp — discover App Service applications
# Get-AzAppServicePlan — discover App Service plans
# Get-AzUserAssignedIdentity — discover managed identities
# Get-AzPolicyAssignment — discover policy assignments
# Get-AzResourceLock — discover resource locks
# Get-AzRoleAssignment — discover RBAC assignments
# Get-AzActivityLog — discover Azure management activity
# Get-AzMetric — discover resource metrics
# Get-AzDiagnosticSetting — discover diagnostic configurations


# Azure

# | Aspect / Concept             | Definition                                                                                                    |
# | ---------------------------- | ------------------------------------------------------------------------------------------------------------- |
# | Tenant                       | Dedicated Microsoft Entra ID instance representing an organization.                                           |
# | Microsoft Entra ID           | Cloud identity and access management service.                                                                 |
# | Management Groups            | Containers used to organize multiple Azure subscriptions.                                                     |
# | Subscriptions                | Billing and management boundaries containing Azure resources.                                                 |
# | Resource Groups              | Logical containers for related Azure resources.                                                               |
# | Resources                    | Individual Azure services or objects you create and manage.                                                   |
# | Regions                      | Geographic locations where Azure resources are hosted.                                                        |
# | Availability Zones           | Physically separate datacenter locations within an Azure region.                                              |
# | Azure Resource Manager / ARM | Azure's management layer for deploying and managing resources.                                                |
# | Azure RBAC                   | Role-based access control for managing who can perform actions on Azure resources.                            |
# | Azure Policy                 | Governance system that enforces organizational rules on Azure resources.                                      |
# | Resource Providers           | Azure services that provide resource types you can deploy and manage.                                         |
# | Tags                         | Key-value metadata used to organize, categorize, and manage resources.                                        |
# | Service Principals           | Identities used by applications or services to authenticate to Azure.                                         |
# | Managed Identities           | Azure-managed identities that allow resources to authenticate to other services without managing credentials. |