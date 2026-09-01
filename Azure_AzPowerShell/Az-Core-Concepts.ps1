# ============================================================

# Azure Core Concepts — Introduction with Azure PowerShell

#

# Concepts covered:
# Tenant, Microsoft Entra ID, Management Groups, Subscriptions,
# Resource Groups, Resources, Regions, Availability Zones,
# Azure Resource Manager (ARM), Azure RBAC, Azure Policy,
# Resource Providers, Tags, Service Principals, Managed Identities

# This script is intentionally focused on discovery and

# understanding the Azure hierarchy.

# ============================================================


# 1. Azure PowerShell

# Install the Az module from PSGallery (PowerShell Gallery), the official public repository for PowerShell modules.
Install-Module -Name Az -Repository PSGallery -Scope CurrentUser


# Load the Az module.
Import-Module Az



# 2. Azure Tenant / Microsoft Entra ID

# A tenant represents the Microsoft Entra ID directory (the identity and access directory for an organization).
# Azure resources are associated with a tenant.
# Sign in to Azure.
Connect-AzAccount

# Display the current Azure context (the active connection and selected Azure environment, tenant, and subscription).
Get-AzContext

# Display the tenant associated with the current context.
Get-AzTenant



# 3. Management Groups

# Management groups organize subscriptions into a hierarchy.
# They are above the subscription level.
# List management groups visible to the current account.
Get-AzManagementGroup



# 4. Subscriptions

# A subscription is a management and billing boundary
# containing Azure resources and resource groups.
# List available subscriptions.
Get-AzSubscription

# Select a subscription for the rest of the session.
Set-AzContext -Subscription "SUBSCRIPTION-NAME"

# Display the currently selected subscription.
Get-AzContext



# 5. Resource Groups

# A resource group is a logical container for Azure resources.
# Resources with a similar lifecycle are commonly grouped together.
# List resource groups.
Get-AzResourceGroup

# Display one specific resource group.
Get-AzResourceGroup -Name "RESOURCE-GROUP-NAME"



# 6. Resources

# Resources are the actual Azure services you deploy,
# such as VMs, storage accounts, networks, and databases.
# List resources in the current subscription.
Get-AzResource

# List resources inside a specific resource group.
Get-AzResource -ResourceGroupName "RESOURCE-GROUP-NAME"



# 7. Regions

# A region is an Azure geographic location where resources
# can be deployed.
# List Azure regions available to the subscription.
Get-AzLocation

# Display region names only.
Get-AzLocation | Select-Object Location, DisplayName


# The difference between Region and Location are:
# Region = the geographic area where Azure resources are hosted.
# Location = the Azure name/identifier used to reference that Region.
# Example: Region = East US, Location = eastus.
# Regions = East US, West US 2, Central US, West Europe, North Europe, Southeast Asia, Australia East, Brazil South, Canada Central, Japan East
# Locations = eastus, westus2, centralus, westeurope, northeurope, southeastasia, australiaeast, brazilsouth, canadacentral, japaneast



# 8. Availability Zones

# Availability Zones are physically separate locations
# within supported Azure regions.
# Not every Azure region or resource supports zones.
# Display regions and their reported availability zones.
Get-AzLocation |
Select-Object Location, DisplayName, Zones



# 9. Azure Resource Manager (ARM)

# ARM is the management layer used to deploy and manage
# Azure resources.

# Az PowerShell commands such as Get-AzResource and
# New-AzResourceGroup operate through Azure Resource Manager.
# Display resources managed through ARM.
Get-AzResource

# Display the ARM resource ID of each resource.
Get-AzResource |
Select-Object Name, ResourceType, ResourceId



# 10. Azure RBAC

# Azure RBAC (Role-Based Access Control) controls who can perform which actions
# at a specific scope.

# Main scopes:
# Management Group
# Subscription
# Resource Group
# Resource
# List role assignments in the current subscription.
Get-AzRoleAssignment

# Display available Azure roles.
Get-AzRoleDefinition |
Select-Object Name, IsCustom, Id



# 11. Azure Policy

# Azure Policy evaluates resources against organizational
# rules and can enforce compliance requirements.
# List policy definitions.
Get-AzPolicyDefinition |
Select-Object DisplayName, PolicyDefinitionId

# List policy assignments.
Get-AzPolicyAssignment |
Select-Object DisplayName, Scope, PolicyDefinitionId



# 12. Resource Providers

# Resource Providers expose resource types to Azure.

# Examples:
# Microsoft.Compute
# Microsoft.Storage
# Microsoft.Network

# List registered resource providers.
Get-AzResourceProvider |
Where-Object RegistrationState -eq "Registered" |
Select-Object ProviderNamespace, RegistrationState

# List resource types provided by Microsoft.Compute.
Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute"



# 13. Tags

# Tags are key/value metadata attached to resources.
# They are commonly used for organization, ownership,
# environment, cost tracking, and automation.

# Display resources and their tags.
Get-AzResource |
Select-Object Name, ResourceType, Tags

# Display resources tagged with Environment.
Get-AzResource |
Where-Object { $_.Tags.Keys -contains "Environment" } |
Select-Object Name, ResourceType, Tags



# 14. Service Principals

# A service principal represents an application identity
# that can authenticate and receive Azure permissions.
# It allows an application or automation tool to access Azure
# resources without using a human user's account.
# List service principals visible to the current account.
Get-AzADServicePrincipal |
Select-Object DisplayName, AppId, Id



# 15. Managed Identities

# Managed identities provide Azure resources with an identity
# in Microsoft Entra ID without storing credentials in code.

# Types:
# System-assigned
# User-assigned

# List user-assigned managed identities.
Get-AzUserAssignedIdentity

# Display managed identities attached to Azure resources.
Get-AzResource |
Where-Object { $_.Identity } |
Select-Object Name, ResourceType, Identity




# 16. Azure Hierarchy — Mental Model

# [Tenant / Microsoft Entra ID]
# ├──> [Users]
# ├──> [Groups]
# ├──> [Service Principals]
# └──> [Managed Identities]

# [Management Group] --> [Subscription] --> [Resource Group] --> [Resource]

# [RBAC (Role-Based Access Control)] ──applies to──> [Management Group / Subscription / Resource Group / Resource]
# [Azure Policy] ──applies to──> [Management Group / Subscription / Resource Group / Resource]


# ------------------------------------------------------------

# Display the current Azure context as the final summary.

Get-AzContext
