Import-Module ActiveDirectory

# Organizational Units (OU)

New-ADOrganizationalUnit -Name "DEPARTMENTS" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Identity "OU=DEPARTMENTS,DC=corp,DC=acme"

New-ADOrganizationalUnit -Name "EMPLOYEES" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Filter 'Name -eq "EMPLOYEES"'

# User Management

$password = ConvertTo-SecureString "YourStrongPassword123!" -AsPlainText -Force

New-ADUser -Name "John Smith" -DisplayName "John Smith" -GivenName "John" -Surname "Smith" -Path "OU=EMPLOYEES,DC=corp,DC=acme" -SamAccountName "jsmith" -UserPrincipalName "jsmith@corp.acme" -AccountPassword $password -Enabled $true

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
# THE STRATEGY IS TO FIRST IDENTIFY THE ORGANIZATIONAL UNITS (OUS), THEN IDENTIFY THE GROUPS, USERS, AND COMPUTER ACCOUNTS CONTAINED IN EACH SPECIFIC OU.

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
# THE STRATEGY IS TO FIRST IDENTIFY THE ORGANIZATIONAL UNITS (OUS), THEN IDENTIFY THE GROUPS, USERS, AND COMPUTER ACCOUNTS CONTAINED IN EACH SPECIFIC OU.

Get-ADOrganizationalUnit -Filter *
Get-ADGroup -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *
Get-ADUser -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *
Get-ADComputer -SearchBase "OU=NAME_OU,DC=corp,DC=acme" -Filter *


