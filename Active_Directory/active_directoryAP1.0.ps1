Import-Module ActiveDirectory

# Organizational Units (OU)

New-ADOrganizationalUnit -Name "DEPARTMENTS" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Identity "OU=DEPARTMENTS,DC=corp,DC=acme"

New-ADOrganizationalUnit -Name "EMPLOYEES" -Path "DC=corp,DC=acme"
Get-ADOrganizationalUnit -Filter 'Name -eq "EMPLOYEES"'

# User Management

$password = ConvertTo-SecureString "YourStrongPassword123!" -AsPlainText -Force

New-ADUser -Name "John Smith" -DisplayName "John Smith" -GivenName "John" -Surname "Smith" -Path "OU=EMPLOYEES,DC=corp,DC=acme" -SamAccountName "jsmith" -UserPrincipalName "[jsmith@corp.acme](mailto:jsmith@corp.acme)" -AccountPassword $password -Enabled $true

Get-ADUser -Identity "jsmith"
Set-ADUser -Identity "jsmith" -EmailAddress "[john.smith@corp.acme](mailto:john.smith@corp.acme)"
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

