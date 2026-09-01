# ============================================================

# Azure Resource Lab with Az PowerShell

#

# Demonstrates:
# Resource Groups, Resources, Regions, ARM (Azure Resource Manager), RBAC (Role-Based Access Control),
# Tags, Resource Providers, Managed Identities
# This script creates a small Azure environment for learning.
# Review the variables before executing.

# ============================================================


# 1. Azure PowerShell

# Import the Az module and sign in to Azure.
Import-Module Az
Connect-AzAccount



# 2. Subscription

# Select the Azure subscription where the lab will be created.
Get-AzSubscription
Set-AzContext -Subscription "SUBSCRIPTION-NAME"
Get-AzContext



# 3. Variables

# Define the names and location used by the lab.
$ResourceGroupName = "rg-az-lab"
$Location = "eastus"
$StorageAccountName = "azlabstorage12345"



# 4. Resource Group

# Create a Resource Group to contain the lab resources.
New-AzResourceGroup `    -Name $ResourceGroupName`
-Location $Location



# 5. Tags

# Tags are key/value metadata used to organize resources,
# identify environments, track ownership, and manage costs.
$Tags = @{
Environment = "Lab"
Purpose     = "Learning"
ManagedBy   = "PowerShell"
}



# 6. Storage Account

# Create an Azure Storage Account as the first resource.
# The resource is created inside the Resource Group and region
# defined above.
New-AzStorageAccount `    -ResourceGroupName $ResourceGroupName`
-Name $StorageAccountName `    -Location $Location`
-SkuName Standard_LRS `    -Kind StorageV2`
-Tag $Tags

# -SkuName specifies the storage account's replication/redundancy configuration.
# Standard_LRS = data is replicated locally within the primary Azure region.
# -Kind specifies the type of storage account.
# StorageV2 = General-purpose v2 storage account, supporting blobs, files, queues, and tables.



# 7. Resources

# View the resources created in the Resource Group.
Get-AzResource `
-ResourceGroupName $ResourceGroupName



# 8. Azure Resource Manager (ARM)

# ARM is Azure's management layer.
# The ResourceId uniquely identifies the resource in Azure.
Get-AzResource `
-ResourceGroupName $ResourceGroupName |
Select-Object Name, ResourceType, ResourceId



# 9. Resource Provider

# Azure resource types are exposed through Resource Providers.
# Microsoft.Storage provides storage-related resources.
Get-AzResourceProvider `
-ProviderNamespace "Microsoft.Storage"



# 10. Tags

# Verify the tags assigned to the resources.
Get-AzResource `
-ResourceGroupName $ResourceGroupName |
Select-Object Name, ResourceType, Tags



# 11. Azure RBAC

# [RBAC (Role-Based Access Control)] controls who can perform actions on Azure resources.
# A role assignment connects:
# Principal + Role + Scope
# Here we inspect the roles available at the Resource Group scope.
Get-AzRoleAssignment `
-ResourceGroupName $ResourceGroupName



# 12. Managed Identity

# A user-assigned managed identity provides an identity in
# Microsoft Entra ID without storing credentials in code.
# The identity can later be assigned permissions through RBAC (Role-Based Access Control).
$IdentityName = "id-az-lab"

New-AzUserAssignedIdentity `    -ResourceGroupName $ResourceGroupName`
-Name $IdentityName `    -Location $Location`
-Tag $Tags



# 13. Managed Identity Verification

# Display the identity and its Microsoft Entra identifiers.
Get-AzUserAssignedIdentity `    -ResourceGroupName $ResourceGroupName`
-Name $IdentityName |
Select-Object Name, ClientId, PrincipalId, Id



# 14. RBAC(Role-Based Access Control) + Managed Identity

# Assign the Storage Blob Data Contributor role to the
# managed identity at the Resource Group scope.
# This demonstrates how an identity receives Azure permissions.
$Identity = Get-AzUserAssignedIdentity `    -ResourceGroupName $ResourceGroupName`
-Name $IdentityName

$StorageRole = Get-AzRoleDefinition `
-Name "Storage Blob Data Contributor"

New-AzRoleAssignment `    -ObjectId $Identity.PrincipalId`
-RoleDefinitionId $StorageRole.Id `
-Scope "/subscriptions/$((Get-AzContext).Subscription.Id)/resourceGroups/$ResourceGroupName"



# 15. Verify RBAC

# Display the role assignment created for the managed identity.
Get-AzRoleAssignment `
-ObjectId $Identity.PrincipalId



# 16. Final Lab Verification

# Display the Resource Group and all resources created.
Get-AzResourceGroup `
-Name $ResourceGroupName

Get-AzResource `
-ResourceGroupName $ResourceGroupName |
Select-Object Name, ResourceType, Location, Tags



# 17. Cleanup

# Uncomment this command when the lab is no longer needed.
# Removing the Resource Group removes the resources contained
# within it.
# Remove-AzResourceGroup -Name $ResourceGroupName -Force

# ============================================================

# Azure Lab Mental Model

# [Tenant / Microsoft Entra ID]
# ├──> [Users / Groups / Service Principals / Managed Identities]
# └──> [Management Group] --> [Subscription] --> [Resource Group] --> [Resources]
# ├──> [Storage Account]
# └──> [Managed Identity]

#

# [RBAC] ──> Principal + Role + Scope
# [ARM] ──> Management Layer ──> Azure Resources
# [Tags] ──> Metadata ──> Azure Resources
# [Region] ──> Geographic Location ──> Azure Resources




# ============================================================
