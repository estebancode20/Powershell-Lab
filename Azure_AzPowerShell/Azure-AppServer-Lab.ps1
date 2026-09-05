# Business Scenario:

# A company needs to deploy an internal Windows application server
# in Azure. The server must be isolated inside a dedicated virtual
# network and protected using Azure networking and identity controls.

#
# Production Requirements

# 1. Resource Organization
# The application environment must have a dedicated Resource Group.
# Resources must use consistent tags for environment, application,
# owner, and management method.

# 2. Azure Region
# Resources must be deployed to an approved Azure Region.
# The Region should be selected based on business requirements such
# as latency, availability, compliance, and cost.

# 3. Network Isolation
# The application server must run inside a dedicated Virtual Network.
# The server must use a dedicated application subnet.
# Network access must be controlled using a Network Security Group.

# 4. Remote Administration
# RDP (Remote Desktop Protocol) must not be open to the entire Internet.
# Administrative access should only be allowed from a trusted
# administrator IP address.

# 5. Application Access

# HTTP access should only be allowed from the application network.
# In a real production environment, HTTPS and additional security
# controls would normally be required.

# 6. Identity
# The virtual machine should use a Managed Identity instead of
# storing credentials or secrets inside scripts.

# 7. Authorization
# Azure RBAC(Role-Based Access Control) must be used to control administrative permissions.
# Permissions should follow the principle of least privilege.

# 8. Compute
# The company requires a Windows Server virtual machine to host
# the internal application.

# 9. Resource Management
# Azure Resource Manager manages the deployment and lifecycle
# of the Azure resources.

# 10. Operations
# Resources must be identifiable through tags and must be suitable
# for monitoring, automation, backup, and future scaling.

# 11. Security
# The application server must not expose unnecessary network ports.
# NSG rules must explicitly define allowed traffic.

# 12. Cleanup
# The complete lab must be removable through the Resource Group
# when testing is finished.

#

# This lab is a simplified production-style architecture.
# A real production environment would normally add components such as
# Azure Monitor, Log Analytics, Backup, Key Vault, Defender for Cloud,
# private endpoints, availability architecture, and infrastructure
# as code.



# 1. Azure PowerShell

# Import only the modules required by this script.

Import-Module Az.Accounts
Import-Module Az.Resources
Import-Module Az.Network
Import-Module Az.Compute

# Sign in to Azure.
Connect-AzAccount


# 2. Subscription

# Display available subscriptions.
Get-AzSubscription

# Select the subscription where the lab will be deployed.
Set-AzContext -Subscription "SUBSCRIPTION-NAME"

# Display the current Azure context.
Get-AzContext


# 3. Variables

# Define the Resource Group and Azure Region.
$ResourceGroupName = "rg-prod-app-lab"
$Location = "eastus"

# Define the network names.
$VNetName = "vnet-prod-app"
$SubnetName = "snet-app"
$NSGName = "nsg-prod-app"

# Define the VM names.
# NIC = Network Interface Card/Controller; provides the VM with network connectivity.
$VMName = "vm-prod-app01"
$NICName = "nic-prod-app01"

# Define the public IP name used only for restricted administration.
$PublicIPName = "pip-prod-app01"

# Define the VM administrator account.
$AdminUsername = "azureadmin"

# Define the administrator's public IP address.
# Replace this value with the trusted administrator IP address.
$AdminIPAddress = "203.0.113.10"

# Define the VM size.
$VMSize = "Standard_B2s"


# 4. Resource Tags

# Tags provide metadata for organization, ownership, automation,
# environment identification, and cost management.
$Tags = @{
Environment = "Production-Lab"
Application = "Internal-App"
Owner       = "IT"
ManagedBy   = "PowerShell"
}


# 5. Resource Group

# Create the Resource Group that will contain the application environment.
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tags


# 6. Virtual Network

# A Virtual Network provides private network connectivity
# between Azure resources.
$VNet = New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix "10.10.0.0/16" -Tag $Tags


# 7. Application Subnet

# A subnet divides the Virtual Network into smaller network segments.
# The application server will be placed inside this subnet.
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet -AddressPrefix "10.10.1.0/24"

# Apply the subnet configuration to the Virtual Network.
$VNet | Set-AzVirtualNetwork


# 8. Network Security Group

# A Network Security Group controls inbound and outbound network traffic.
# Create the NSG.
$NSG = New-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $ResourceGroupName -Location $Location -Tag $Tags


# 9. RDP Security Rule

# Allow RDP (Remote Desktop Protocol) only from the trusted administrator IP address.
# RDP must never be exposed to the entire Internet.
$RDPRule = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP-Admin" -Description "Allow RDP only from trusted administrator IP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix $AdminIPAddress -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 3389


# 10. HTTP Security Rule

# Allow HTTP traffic for the internal application.
# In a real production environment, HTTPS would normally be preferred.
$HTTPRule = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP-App" -Description "Allow application HTTP traffic" -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 -SourceAddressPrefix "10.10.0.0/16" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 80


# 11. Apply NSG Rules

# Add the security rules to the Network Security Group.
$NSG.SecurityRules.Add($RDPRule)
$NSG.SecurityRules.Add($HTTPRule)

# Save the Network Security Group configuration.
$NSG | Set-AzNetworkSecurityGroup

# 12. Associate NSG with Subnet

# Associate the Network Security Group with the application subnet.
$VNet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet
$Subnet.NetworkSecurityGroup = $NSG
$VNet | Set-AzVirtualNetwork

# 13. Public IP

# Create a public IP address for restricted administrative access.
# In production, Azure Bastion (secure VM administration service)
# is often preferred because it provides RDP (Remote Desktop Protocol)
# / SSH access to VMs without requiring the VM itself to have
# a public IP address.
# Bastion connects to the VM through its private IP address,
# reducing direct exposure of administrative ports to the Internet.

$PublicIP = New-AzPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Static -Sku Standard -Tag $Tags


# 14. Network Interface

# Create a Network Interface that connects the VM to the application subnet.
$VNet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $Subnet.Id -PublicIpAddressId $PublicIP.Id -NetworkSecurityGroupId $NSG.Id -Tag $Tags

# 15. Virtual Machine Configuration

# Create the VM configuration.
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize

# Configure Windows Server.
$VMConfig = Set-AzVMOperatingSystem -VM $VMConfig -Windows -ComputerName $VMName -Credential (Get-Credential -UserName $AdminUsername -Message "Enter the Windows Server administrator password") -ProvisionVMAgent -EnableAutoUpdate

# Select a Windows Server image.
$VMConfig = Set-AzVMSourceImage -VM $VMConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-datacenter-azure-edition" -Version "latest"

# Attach the Network Interface to the VM.
$VMConfig = Add-AzVMNetworkInterface -VM $VMConfig -Id $NIC.Id

# 16. Virtual Machine Deployment

# Create the Windows Server virtual machine.
# The VM is deployed inside the Resource Group, Region,
# Virtual Network, and subnet defined above.
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig -Tag $Tags

# 17. Managed Identity

# Enable a system-assigned Managed Identity on the VM.
# This allows the VM to authenticate to Azure services
# without storing credentials in the operating system or script.
Update-AzVM -ResourceGroupName $ResourceGroupName -VM (Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName) -IdentityType SystemAssigned

# 18. Managed Identity Verification

# Display the VM identity information.
Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName |
Select-Object Name, Location, Identity

# 19. Azure RBAC

# Azure RBAC (Role-Based Access Control) controls who can perform
# actions on Azure resources.
# The RBAC model is:
# Principal + Role + Scope
# Display the Resource Group scope.
$ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName

$ResourceGroup.ResourceId

# 20. Resource Verification

# Display all resources created by the lab.
Get-AzResource -ResourceGroupName $ResourceGroupName |
Select-Object Name, ResourceType, Location, Tags

# 21. Network Verification

# Display the Virtual Network and subnet configuration.
Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName |
Select-Object Name, Location, AddressSpace, Subnets

# Display the Network Security Group rules.
Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName |
Select-Object Name, SecurityRules

# 22. VM Verification

# Display the VM configuration.
Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName |
Select-Object Name, Location, HardwareProfile, ProvisioningState

# 23. Public IP Verification

# Display the public IP address assigned to the VM.
Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $PublicIPName |
Select-Object Name, IpAddress, AllocationMethod

# 24. Final Lab Summary

# Display the complete Resource Group.
Get-AzResourceGroup -Name $ResourceGroupName

# Display all resources and their main properties.
Get-AzResource -ResourceGroupName $ResourceGroupName |
Select-Object Name, ResourceType, Location, ResourceId, Tags

# 25. Cleanup
# Uncomment this command when the lab is no longer needed.
# Removing the Resource Group removes all resources contained
# within the application environment.
# Remove-AzResourceGroup -Name $ResourceGroupName -Force



# Azure Production-Style Mental Model
# [Tenant / Microsoft Entra ID]
# ├──> [Managed Identity]
# └──> [Management Group] --> [Subscription] --> [Resource Group]
# │
# ├──> [Virtual Network]
# │    └──> [Application Subnet]
# │         └──> [Windows VM]
# │
# ├──> [Network Security Group]
# ├──> [Network Interface]
# └──> [Public IP]

#

# [NSG] ──> Network Traffic Control
# [RBAC](Role-Based Access Control) ──> Principal + Role + Scope
# [Managed Identity] ──> Azure Identity Without Stored Credentials
# [ARM] ──> Azure Resource Management Layer
# [Tags] ──> Resource Metadata
# [Region] ──> Geographic Azure Location


