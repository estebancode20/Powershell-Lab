Import-Module ActiveDirectory

# Organizational Units (OU)

New-ADOrganizationalUnit -Name "DEPARTMENTS" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Identity "OU=DEPARTMENTS,DC=corp,DC=acme"

New-ADOrganizationalUnit -Name "EMPLOYEES" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Filter 'Name -eq "EMPLOYEES"'

# User Management

$password = ConvertTo-SecureString "YourStrongPassword123!" -AsPlainText -Force

New-ADUser -Name "John Smith" -DisplayName "John Smith" -GivenName "John" -Surname "Smith" -Path "OU=EMPLOYEES,DC=corp,DC=acme" -SamAccountName "jsmith" -UserPrincipalName "jsmith@corp.acme" -AccountPassword $password -Enabled $true

# Creates the second user, Michael Anderson, who is not a member of IT-STAFF.
New-ADUser -Name "Michael Anderson" -DisplayName "Michael Anderson" -GivenName "Michael" -Surname "Anderson" -Path "OU=EMPLOYEES,DC=corp,DC=acme" -SamAccountName "manderson" -UserPrincipalName "manderson@corp.acme" -AccountPassword $password -Enabled $true

# Resets Michael Anderson's password.
Set-ADAccountPassword -Identity "manderson" -Reset -NewPassword (ConvertTo-SecureString "Test123!" -AsPlainText -Force)

# Resets John Smith's password.
Set-ADAccountPassword -Identity "jsmith" -Reset -NewPassword (ConvertTo-SecureString "Test123!" -AsPlainText -Force)


Get-ADUser -Identity "jsmith"
Set-ADUser -Identity "jsmith" -EmailAddress "john.smith@corp.acme"
Get-ADUser -Identity "jsmith" -Properties EmailAddress | Select-Object Name, EmailAddress

# Group Management

New-ADGroup -Name "IT-STAFF" -SamAccountName "IT-STAFF" -GroupCategory Security -GroupScope Global -Path "OU=DEPARTMENTS,DC=corp,DC=acme"
Get-ADGroup -Identity "IT-STAFF"
Add-ADGroupMember -Identity "IT-STAFF" -Members "jsmith"
Get-ADGroupMember -Identity "IT-STAFF"
Get-ADGroup -Identity "IT-STAFF" -Properties Description, GroupCategory, GroupScope, Members

# Cleanup: User and OU Removal

# Removes the John Smith user object from Active Directory in the corp.acme domain
Remove-ADObject -Identity "CN=John Smith,OU=EMPLOYEES,DC=corp,DC=acme" -Confirm:$false
Get-ADUser -Identity "jsmith"
Get-ADOrganizationalUnit -Identity "OU=EMPLOYEES,DC=corp,DC=acme" -Properties ProtectedFromAccidentalDeletion
Set-ADOrganizationalUnit -Identity "OU=EMPLOYEES,DC=corp,DC=acme" -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit -Identity "OU=EMPLOYEES,DC=corp,DC=acme" -Confirm:$true


# ---
Install-WindowsFeature

Get-WindowsFeature

Install-ADDSForest

Get-ADDomain

Get-ADForest

Get-ADDomainController

# ---

# OUs = structure / management
# Groups = permissions / access
# why permissions should never be assigned to OUs

# ---

# Creates a computer account named WS-CLIENT-01 in the default Computers container.
New-ADComputer -Name "WS-CLIENT-01"

# Creates WS-CLIENT-02 and places its computer account directly in the DEPARTMENTS Organizational Unit (OU).
New-ADComputer -Name "WS-CLIENT-02" -Path "OU=DEPARTMENTS,DC=corp,DC=acme"

# ---

# Adds the user account jsmith to the IT-STAFF group using SamAccountName.
Add-ADGroupMember -Identity "IT-STAFF" -Members "jsmith"

# Adds the computer account WS-CLIENT-02 to the IT-STAFF group using SamAccountName.
Add-ADGroupMember -Identity "IT-STAFF" -Members "WS-CLIENT-02$"

# Lists the members of the IT-STAFF group and their main identity properties.
Get-ADGroupMember -Identity "IT-STAFF" 

# ---
# PERMISSION

# Creates the folder that will be used to test access permissions.
New-Item -Path "C:\CompanyData\IT" -ItemType Directory -Force

# Creates a test file inside the protected folder.
Set-Content -Path "C:\CompanyData\IT\SecurityTest.txt" -Value @"
CONFIDENTIAL IT DEPARTMENT DATA

This file is used to test NTFS permissions.

Authorized group: CORP\IT-STAFF
Permission: Read and Execute
Test user outside the group: manderson
"@

# The CORP part is the NetBIOS domain name, not the DNS domain name.
# The NetBIOSName property contains the short name of the Active Directory domain used in
# traditional Windows security-principal notation such as CORP\IT-STAFF.
# Displays the NetBIOS domain name.
Get-ADDomain
Get-ADDomain | Select-Object NetBIOSName

# Gets the folder's Access Control List (ACL) and disables inherited permissions.
$Acl = Get-Acl "C:\CompanyData\IT"
$Acl.SetAccessRuleProtection($true, $false)

# Grants IT-STAFF Read and Execute permission on the folder and its contents.
$Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("CORP\IT-STAFF","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")))
$Acl.AddAccessRule(
    (New-Object System.Security.AccessControl.FileSystemAccessRule(
        "CORP\IT-STAFF",       # Who receives the permission
        "ReadAndExecute",      # What they are allowed to do
        "ContainerInherit,ObjectInherit", # Apply to subfolders and files
        "None",                # No inheritance flags
        "Allow"                # Allow the specified access
    ))
)
Set-Acl "C:\CompanyData\IT" $Acl

# Displays the folder's Access Control Entries (ACEs).
Get-Acl "C:\CompanyData\IT" | Select-Object -ExpandProperty Access


# Grants the local Administrators group full control over the folder.
$Acl = Get-Acl "C:\CompanyData\IT"
$Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow")))
Set-Acl "C:\CompanyData\IT" $Acl

#Displays the folder's Access Control Entries (ACEs).
Get-Acl "C:\CompanyData\IT" | Select-Object -ExpandProperty Access


# Grants IT-STAFF Read and Execute permission on the folder and its contents.
$Acl = Get-Acl "C:\CompanyData\IT"
$Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("CORP\IT-STAFF","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")))
Set-Acl "C:\CompanyData\IT" $Acl

# Displays the folder's Access Control Entries (ACEs).
Get-Acl "C:\CompanyData\IT" | Select-Object -ExpandProperty Access


# ---
# SERVER MESSAGE BLOCK (SMB)

# SMB (Server Message Block): network protocol used to access shared files, folders, printers, and other resources.
# SMB share: a folder exposed over the network through a share name.
# UNC path: Universal Naming Convention path used to access an SMB resource, such as \SERVER01\CompanyData.
# SMB server: computer that provides SMB shares.
# SMB client: computer that connects to an SMB share.
# SMB share permissions: control network access to the shared resource.
# NTFS permissions: control access to the actual files and folders.
# Effective access: when accessing a resource through SMB, both SMB share permissions and NTFS permissions can affect the resulting access.

# Displays the folder's Access Control Entries (ACEs).
Get-Acl "C:\CompanyData\IT" | Select-Object -ExpandProperty Access

# Creates an SMB share named IT on the existing folder.
# Grants the CORP\IT-STAFF group read access to the SMB share.
New-SmbShare -Name "IT" -Path "C:\CompanyData\IT" -ReadAccess "CORP\IT-STAFF"

# Lists the SMB shares on the server.
Get-SmbShare

# Displays detailed information about the IT SMB share.
Get-SmbShare -Name "IT"

# Tests access to the SMB share through its UNC path.
Test-Path "\\WS-CORE-01\IT"

# Grants the local Administrators group full access to the SMB share.
Grant-SmbShareAccess -Name "IT" -AccountName "BUILTIN\Administrators" -AccessRight Full -Force

# Verifies the SMB share permissions.
Get-SmbShareAccess -Name "IT"

# Tests access to the SMB share through its UNC path.
Test-Path "\\WS-CORE-01\IT"

# ---
# GROUP POLICY OBJECTS (GPO)
# A GPO contains centralized configuration settings that can be applied to users and computers;
# an OU is a container that organizes AD objects and can be used as the target where a GPO is linked.

# Lists all Group Policy Objects (GPOs) in the domain.
Get-GPO -All

# Lists all GPOs with their display name and identifier.
Get-GPO -All | Select-Object DisplayName, Id

# Creates a test GPO named "DEPARTMENTS-TEST".
New-GPO -Name "DEPARTMENTS-TEST"

# Links the GPO to the DEPARTMENTS Organizational Unit.
New-GPLink -Name "DEPARTMENTS-TEST" -Target "OU=DEPARTMENTS,DC=corp,DC=acme"

# Configures the GPO to disable Command Prompt for users.
Set-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD" -Type DWord -Value 1

# Configures the GPO to disable Task Manager for users.
Set-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "DisableTaskMgr" -Type DWord -Value 1

# Removes the DisableCMD setting from the GPO.
Remove-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD"

# Removes the DisableTaskMgr setting from the DEPARTMENTS-TEST GPO.
Remove-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "DisableTaskMgr"

# Forces the computer to refresh Group Policy settings.
gpupdate /force

# Generates a report showing the Group Policy settings applied to the computer.
gpresult /r

# Displays general information about a specific GPO.
Get-GPO -Name "DEPARTMENTS-TEST" | Format-List *

# Lists the GPO links configured for an Organizational Unit (OU).
Get-GPInheritance -Target "OU=DEPARTMENTS,DC=corp,DC=acme"

# Lists GPO links for the entire domain.
Get-GPInheritance -Target "DC=corp,DC=acme"

# Lists the policy settings configured in the GPO through the specified registry path.
Get-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Policies\Microsoft\Windows\System"

# Lists the Registry-based Policy Settings Configured in the DEPARTMENTS-TEST GPO under the specified Registry Key.
Get-GPRegistryValue -Name "DEPARTMENTS-TEST" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"



# ---------------------------------------------------------------------------------------------------------------------------------
# WORKFLOW TO DEEP IN WINDOWS SERVER

# FOREST: The highest AD DS level. Shows information about the entire forest.
# Focus: forest structure and functional level.
Get-ADForest | Select-Object Name, RootDomain, Domains, ForestMode

# DOMAIN: A logical partition inside the forest. Shows information about one AD domain.
# Focus: domain identity, functional level, and FSMO (Flexible Single Master Operations).
# FSMO roles are special Active Directory roles assigned to specific domain controllers.
# This command shows the domain-level FSMO role owner.
Get-ADDomain | Select-Object DNSRoot, DomainMode, DomainControllers, PDCEmulator


# DOMAIN CONTROLLER: A server that hosts AD DS for a domain.
# Focus: the specific Domain Controller (DC) identity, network location, and role.
Get-ADDomainController | Select-Object HostName, IPv4Address, Site, IsGlobalCatalog

# ---

# Displays all properties of the first Windows feature using list format.
Get-WindowsFeature | Select-Object -First 1 | Format-List

# Lists the Active Directory Domain Services role and its installation status.
Get-WindowsFeature -Name AD-Domain-Services

# Lists the Active Directory Certificate Services role and its installation status.
Get-WindowsFeature -Name AD-Certificate

# Lists the Microsoft Internet Information Services (IIS) web server role and its installation status.
# IIS is Microsoft's web server software for hosting websites, web applications, and web services.
Get-WindowsFeature -Name Web-Server

# Lists the first five Windows features with InstallState set to Installed, Available, or Removed.
Get-WindowsFeature | Where-Object InstallState -eq "Installed" | Select-Object -First 5

# ---
# THE STRATEGY IS TO FIRST IDENTIFY THE ORGANIZATIONAL UNITS (OUS), THEN IDENTIFY THE GROUPS, USERS, COMPUTER ACCOUNTS, AND GROUP MEMBERSHIPS WITHIN EACH OU.

# Lists all Organizational Units in the current domain.
Get-ADOrganizationalUnit -Filter *

# Lists all Organizational Unit properties, including hidden properties not returned by default.
# -Filter * retrieves the Organizational Units; -Properties * retrieves all available properties, including hidden properties not returned by default.
Get-ADOrganizationalUnit -Filter * -Properties * | Select-Object *

# Lists all OUs and explicitly retrieves the accidental-deletion protection property.
# This property is not retrieved by default, so -Properties requests it from Active Directory.
Get-ADOrganizationalUnit -Filter * -Properties ProtectedFromAccidentalDeletion | Select-Object Name, DistinguishedName, ProtectedFromAccidentalDeletion

# ---

# Lists all user accounts in the current Active Directory domain.
Get-ADUser -Filter *

# List a specific user
Get-ADUser -Identity "jsmith"

# Lists all user accounts located directly in the specified Organizational Unit (OU).
Get-ADUser -SearchBase "OU=EMPLOYEES,DC=corp,DC=acme" -Filter *


# ---

# Lists all groups located in the DEPARTMENTS Organizational Unit (OU).
# This is a tactic to identify groups that belong to a specific Organizational Unit (OU).
# The -SearchBase value is the Distinguished Name (DN) of the Organizational Unit (OU) to search.
Get-ADGroup -SearchBase "OU=DEPARTMENTS,DC=corp,DC=acme" -Filter *

# ---

# Lists all computer accounts in the current Active Directory domain.
Get-ADComputer -Filter *

# Retrieves a specific computer account by its name.
Get-ADComputer -Identity "WS-CLIENT-01"

# Lists all computer accounts in a specific Organizational Unit (OU).
Get-ADComputer -SearchBase "OU=DEPARTMENTS,DC=corp,DC=acme" -Filter *

# ---

# Lists the members of a specific Active Directory group.
Get-ADGroupMember -Identity "IT-STAFF"

# ---

# Lists the Active Directory groups to which the user belongs.
Get-ADPrincipalGroupMembership -Identity "jsmith" | Select-Object Name, GroupScope, GroupCategory

# ---

# Lists folders under C:\ that have explicit Access Control Entries (ACEs).
Get-ChildItem "C:\" -Directory -Recurse -ErrorAction SilentlyContinue |
    ForEach-Object { Get-Acl $_.FullName } |
    Where-Object { $_.AreAccessRulesProtected -or $_.Access.Count -gt 0 } |
    Select-Object Path, AreAccessRulesProtected, Access


# ---

# THE STRATEGY IS TO FIRST IDENTIFY THE ORGANIZATIONAL UNITS (OUS), THEN IDENTIFY THE GROUPS, USERS, COMPUTER ACCOUNTS, GROUP MEMBERSHIPS WITHIN EACH OU, AND GROUP POLICY OBJECTS (GPOS).

Get-ADOrganizationalUnit -Filter *
Get-ADGroup -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *
Get-ADUser -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *
Get-ADComputer -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *
Get-ADGroupMember -Identity "IT-STAFF"
Get-ADPrincipalGroupMembership -Identity "jsmith"
Get-GPO -All
Get-GPInheritance -Target "OU=DEPARTMENTS,DC=corp,DC=acme"

# ---

# CURRENT ACTIVE DIRECTORY STRUCTURE
# corp.acme
# │
# ├── OU=DEPARTMENTS
# │ ├── Group: IT-STAFF
# │ │ ├── User: John Smith
# │ │ └── Computer: WS-CLIENT-02
# │
# ├── OU=EMPLOYEES
# │ ├── User: John Smith
# │ └── User: Michael Anderson
# │
# └── CN=Computers (Default Computer Container)
# └── Computer: WS-CLIENT-01
# SMB
# └── Share: IT
# └── Path: C:\CompanyData\IT

