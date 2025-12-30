# Import the Active Directory module to enable AD cmdlets
Import-Module ActiveDirectory

# Retrieve user information for an employee account and store it in a variable
$user = Get-ADUser -Identity "bwilson" -Properties *

# Display the full Distinguished Name (DN)
# Shows the exact LDAP location of the user in Active Directory
$user.DistinguishedName

# Display the employee's first name
$user.GivenName

# Save the employee's first name to a text file
$user.GivenName | Out-File "employees.txt"

# Update the employee's surname
Set-ADUser -Identity "bwilson" -Surname "Anderson"

# Retrieve the updated user information
Get-ADUser -Identity "bwilson" -Properties GivenName,Surname

# Add the employee to an IT security group
Add-ADGroupMember `
  -Identity "IT-Admins" `
  -Members "bwilson"

# Remove the employee from the IT security group
Remove-ADGroupMember `
  -Identity "IT-Admins" `
  -Members "bwilson" `
  -Confirm:$false

# SAM (Security Account Manager) stores user credentials and security identifiers
# Create a new employee account in the corporate directory
New-ADUser `
  -Name "Emily Carter" `
  -GivenName "Emily" `
  -Surname "Carter" `
  -SamAccountName "ecarter" `
  -UserPrincipalName "ecarter@company.com" `
  -Path "OU=Employees,OU=Administration,OU=Company,DC=company,DC=com" `
  -AccountPassword (ConvertTo-SecureString "SecurePass123!" -AsPlainText -Force) `
  -Enabled $true

# Reset the password for the employee account
Set-ADAccountPassword `
  -Identity "ecarter" `
  -Reset `
  -NewPassword (ConvertTo-SecureString "NewSecure456!" -AsPlainText -Force)

# List all enabled employee accounts in Active Directory
Get-ADUser -Filter 'Enabled -eq $true' |
Select-Object Name, SamAccountName

# List employee accounts whose passwords never expire
Get-ADUser -Filter 'PasswordNeverExpires -eq $true' |
Select-Object Name, SamAccountName

# List members of a privileged administrative group
Get-ADGroupMember "Domain Admins" |
Select-Object Name, ObjectClass
