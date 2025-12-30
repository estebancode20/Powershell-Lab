# Load the Scheduled Tasks module
Import-Module ScheduledTasks

# Create a weekly trigger (Sunday at 16:00)
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 16:00

# Define the action: run the cleanup worker script
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument '-NoProfile -File "C:\Scripts\Test-CleanupArtifacts.ps1"'

# Register (or overwrite) the scheduled task
Register-ScheduledTask `
    -TaskName "CleanupArtifacts" `
    -Trigger $trigger `
    -Action $action `
    -Force
