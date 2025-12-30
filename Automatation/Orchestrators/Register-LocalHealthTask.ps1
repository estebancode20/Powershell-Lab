# Load the Scheduled Tasks module (needed to manage scheduled tasks)
Import-Module ScheduledTasks

# Create a daily trigger that runs at 15:00
$trigger = New-ScheduledTaskTrigger -Daily -At 15:00

# Define the action: run PowerShell and execute the worker script
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `               # PowerShell executable
    -Argument '-NoProfile -File "C:\Scripts\Test-LocalHealth.ps1"' # Script to run

# Register (or overwrite) the scheduled task
Register-ScheduledTask `
    -TaskName "LocalHealthCheck" `             # Task name in Task Scheduler
    -Trigger $trigger `                        # When the task runs
    -Action $action `                          # What the task runs
    -Force                                     # Replace if it already exists
