# ============================================================
# WINDOWS SERVER CORE ADMINISTRATION WITH POWERSHELL
# CORPORATE / ENTERPRISE ACTIVE DIRECTORY LAB
# ============================================================

# ------------------------------------------------------------
# 1. Introduction
# 2. Distinguished Names (DN)
# 3. Managing Organizational Units (OUs)
# 4. Managing User Accounts
# 5. Managing Groups
# 6. Managing Computer Accounts
# 7. Moving Objects
# ------------------------------------------------------------

# ============================================================
# 1. Managing Computer Accounts using PowerShell
# ============================================================

# List all computer accounts in the WORKSTATIONS OU
Get-ADComputer -SearchBase "OU=WORKSTATIONS,DC=corp,DC=example" -Filter *

# Create a new computer account
New-ADComputer `
  -Enabled $true `
  -Path "OU=WORKSTATIONS,DC=corp,DC=example" `
  -Name "PC-HQ-01" `
  -SamAccountName "PC-HQ-01$"

# Verify computer creation
Get-ADComputer -SearchBase "OU=WORKSTATIONS,DC=corp,DC=example" -Filter *

# Modify computer description
Set-ADComputer `
  -Identity "CN=PC-HQ-01,OU=WORKSTATIONS,DC=corp,DC=example" `
  -Replace @{ Description = "Headquarters workstation 01" }

# Remove computer account
Remove-ADObject `
  -Identity "CN=PC-HQ-01,OU=WORKSTATIONS,DC=corp,DC=example" `
  -Confirm:$false

# ============================================================
# 2. User Management using PowerShell
# ============================================================

# List all user accounts in EMPLOYEES OU
Get-ADUser -SearchBase "OU=EMPLOYEES,DC=corp,DC=example" -Filter *

# Create a new employee user
New-ADUser `
  -Name "John Smith" `
  -DisplayName "John Smith" `
  -GivenName "John" `
  -Surname "Smith" `
  -Path "OU=EMPLOYEES,DC=corp,DC=example" `
  -SamAccountName "jsmith" `
  -UserPrincipalName "jsmith@corp.example" `
  -Enabled $true

# Reset user password
Set-ADAccountPassword `
  -Identity "jsmith" `
  -NewPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
  -Reset $true

# Enable user account
Enable-ADAccount -Identity "jsmith"

# Configure account control options
Set-ADAccountControl `
  -Identity "jsmith" `
  -PasswordNeverExpires $false `
  -CannotChangePassword $false `
  -DoesNotRequirePreAuth $false

# Force password change at next logon
Set-ADUser `
  -Identity "jsmith" `
  -ChangePasswordAtLogon $true

# Set corporate email address
Set-ADUser `
  -Identity "jsmith" `
  -EmailAddress "john.smith@corp.example"

# Remove user account
Remove-ADObject `
  -Identity "CN=John Smith,OU=EMPLOYEES,DC=corp,DC=example" `
  -Confirm:$false

# ============================================================
# 3. Managing Organizational Units (OUs)
# ============================================================

# List all Organizational Units
Get-ADOrganizationalUnit -Filter *

# Create DEPARTMENTS OU
New-ADOrganizationalUnit `
  -Name "DEPARTMENTS" `
  -Path "DC=corp,DC=example" `
  -ProtectedFromAccidentalDeletion $true

# Create IT department OU
New-ADOrganizationalUnit `
  -Name "IT" `
  -Path "OU=DEPARTMENTS,DC=corp,DC=example"

# Rename IT OU
Rename-ADObject `
  -Identity "OU=IT,OU=DEPARTMENTS,DC=corp,DC=example" `
  -NewName "INFORMATION_TECHNOLOGY"

# Remove accidental deletion protection
Set-ADObject `
  -Identity "OU=INFORMATION_TECHNOLOGY,OU=DEPARTMENTS,DC=corp,DC=example" `
  -ProtectedFromAccidentalDeletion $false

# Delete the OU
Remove-ADObject `
  -Identity "OU=INFORMATION_TECHNOLOGY,OU=DEPARTMENTS,DC=corp,DC=example" `
  -Confirm:$false

# ============================================================
# 4. Active Directory General Information
# ============================================================

# Display domain information
Get-ADDomain

# Display forest information
Get-ADForest

# ============================================================
# 5. Managing Groups using PowerShell
# ============================================================

# List all groups
Get-ADGroup -Filter *

# Create a security group for IT staff
New-ADGroup `
  -Name "IT-STAFF" `
  -SamAccountName "IT-STAFF" `
  -GroupCategory Security `
  -GroupScope Global `
  -Path "OU=DEPARTMENTS,DC=corp,DC=example"

# Set group description
Set-ADGroup `
  -Identity "CN=IT-STAFF,OU=DEPARTMENTS,DC=corp,DC=example" `
  -Description "IT Department Staff Group"

# Add user to group
Add-ADGroupMember `
  -Identity "CN=IT-STAFF,OU=DEPARTMENTS,DC=corp,DC=example" `
  -Members "jsmith"

# List group members
Get-ADGroupMember `
  -Identity "CN=IT-STAFF,OU=DEPARTMENTS,DC=corp,DC=example"

# Remove user from group
Remove-ADGroupMember `
  -Identity "CN=IT-STAFF,OU=DEPARTMENTS,DC=corp,DC=example" `
  -Members "jsmith" `
  -Confirm:$false

# ============================================================
# 6. Promote Server to Domain Controller (Server Core)
# ============================================================

# Install AD DS role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Import deployment module
Import-Module ADDSDeployment

# Promote server and create new forest
Install-ADDSForest `
  -CreateDnsDelegation:$false `
  -DatabasePath "C:\Windows\NTDS" `
  -DomainMode "WinThreshold" `
  -DomainName "corp.example" `
  -DomainNetbiosName "CORP" `
  -ForestMode "WinThreshold" `
  -InstallDns:$true `
  -LogPath "C:\Windows\NTDS" `
  -SysvolPath "C:\Windows\SYSVOL" `
  -Force:$true

# ============================================================
# 7. Demote a Domain Controller
# ============================================================

# Import AD DS deployment module
Import-Module ADDSDeployment

# Demote domain controller
Uninstall-ADDSDomainController `
  -DemoteOperationMasterRole:$true `
  -ForceRemoval:$true `
  -Force:$true

# Remove AD DS role
Uninstall-WindowsFeature AD-Domain-Services

# Verify features
Get-WindowsFeature -ComputerName "SERVER-CORE-01"

# ============================================================
# 8. Disk and Partition Management (Server Core)
# ============================================================

# List disks
Get-Disk

# Initialize disk 2 with MBR
Initialize-Disk -Number 2 -PartitionStyle MBR

# Create BACKUPS volume
New-Partition -DiskNumber 2 -Size 2GB -DriveLetter E
Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel "BACKUPS"

# Create FILES volume
New-Partition -DiskNumber 2 -UseMaximumSize -DriveLetter F
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel "FILES"

# Verify partitions
Get-Partition
