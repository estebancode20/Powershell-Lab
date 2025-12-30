# Load the Scheduled Tasks module
Import-Module ScheduledTasks

# Create a daily trigger at 15:30
$trigger = New-ScheduledTaskTrigger -Daily -At 15:30

# Define the action: run the user permissions audit worker
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument '-NoProfile -File "C:\Scripts\Test-UserPermissions.ps1"'

# Register (or overwrite) the scheduled task
Register-ScheduledTask `
    -TaskName "UserPermissionsAudit" `
    -Trigger $trigger `
    -Action $action `
    -Force
