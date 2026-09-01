# ==============================================
# Active Directory mental model (correct)
#
# OU       -> Container (defines object location and GPO scope)
# User     -> Object created in ONE OU only
# Group    -> Object created in ONE OU only
# Computer -> Object created in ONE OU only
#
# Group membership -> Relationship (link), NOT location
#
# A user object remains in its OU regardless of
# which groups (and their OUs) it belongs to.
#
# IMPORTANT:
# - There is NO ownership property between User and Computer in AD.
# - A user is NOT assigned to a computer.
# - A computer is NOT assigned to a user.
# - AD controls who is ALLOWED to log on, via groups and GPOs.
#
# A user or computer object NEVER changes OU
# because of group membership.
# ==============================================


# [Domain: corp.acme]
# │
# ├── OU: IT
# │   ├── Group: IT-Admins
# │   ├── Group: IT-Support
# │   ├── User Object: alice
# │   │   └── Member of:
# │   │       ├── IT-Admins            (OU: IT)
# │   │       └── Network-Operators    (OU: Network)
# │   └── Computer Object: IT-PC-01
# │       └── Logon allowed via:
# │           └── Group membership + GPOs
# │
# ├── OU: Network
# │   ├── Group: Network-Admins
# │   ├── Group: Network-Operators
# │   └── Computer Object: NET-PC-01
# │
# └── OU: Finance
#     ├── Group: Finance-Admins
#     ├── Group: Finance-Users
#     ├── User Object: bob
#     │   └── Member of: none
#     └── Computer Object: FIN-PC-01
#
# NOTE:
# - Physical assignment of a computer to an employee is OUTSIDE AD.
# - Any user with valid credentials AND permission can log on.
# ==============================================


# Create Organizational Units (OUs)
New-ADOrganizationalUnit -Name "IT" -Path "DC=corp,DC=acme"
New-ADOrganizationalUnit -Name "Network" -Path "DC=corp,DC=acme"
New-ADOrganizationalUnit -Name "Finance" -Path "DC=corp,DC=acme"


# Create Groups (each group exists in ONE OU)
New-ADGroup -Name "IT-Admins" `
  -GroupScope Global `
  -Path "OU=IT,DC=corp,DC=acme"

New-ADGroup -Name "Network-Operators" `
  -GroupScope Global `
  -Path "OU=Network,DC=corp,DC=acme"


# Create Users (each user object exists in ONE OU)
New-ADUser -Name "alice" `
  -SamAccountName "alice" `
  -Path "OU=IT,DC=corp,DC=acme" `
  -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
  -Enabled $true

New-ADUser -Name "bob" `
  -SamAccountName "bob" `
  -Path "OU=Finance,DC=corp,DC=acme" `
  -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
  -Enabled $true


# Create Computer Objects (each computer exists in ONE OU)
New-ADComputer -Name "IT-PC-01" `
  -Path "OU=IT,DC=corp,DC=acme"

New-ADComputer -Name "NET-PC-01" `
  -Path "OU=Network,DC=corp,DC=acme"

New-ADComputer -Name "FIN-PC-01" `
  -Path "OU=Finance,DC=corp,DC=acme"


# Add Users to Groups
# This creates authorization relationships ONLY.
# It does NOT assign users to computers.
# It does NOT move objects between OUs.
Add-ADGroupMember -Identity "IT-Admins" -Members "alice"
Add-ADGroupMember -Identity "Network-Operators" -Members "alice"