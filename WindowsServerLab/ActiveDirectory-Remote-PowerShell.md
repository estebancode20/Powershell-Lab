# Active Directory Administration via Remote PowerShell

## Objective
Demonstrate basic Active Directory management directly on Windows Server Core using PowerShell, including OU, user, group, and cleanup tasks.

## Environment

- Server Core IP: `192.168.56.101`
- Active Directory module imported: `Import-Module ActiveDirectory`

## Execution Proof

### Organizational Units (OU)
![OUList](images/ad_create_ou1.0.png)  
![CreateOU](images/ad_create_ou1.1.png)  

### User Management
![CreateUser](images/ad_create_user1.0.png)
![ListUser](images/ad_create_user1.1.png)  
![ModifyUser](images/ad_modify_user.png)  

### Group Management
![CreateGroup](images/ad_create_group.png)
![AddGroupMembers](images/ad_add_group_members.png)
![GroupDetails](images/ad_group_details.png)  

### Cleanup (User and OU Removal)
![CleanupUserObject](images/ad_cleanup_user_object.png)
![DisableOUDeletionProtection](images/ad_disable_ou_deletion_protection.png) 
![CleanupEmployeesOU](images/ad_cleanup_employees_ou.png) 
