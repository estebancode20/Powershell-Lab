try {
    # List local users and groups
    $users = Get-LocalUser | Select-Object -First 10
    $groups = Get-LocalGroup | Select-Object -First 10

    # List automatic services not running (already familiar)
    $stoppedServices = Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' } | Select-Object -First 10

    # Simple report
    $report = @"
Time: $(Get-Date)
First 10 Users: $($users.Name -join ', ')
First 10 Groups: $($groups.Name -join ', ')
Stopped Auto Services: $($stoppedServices.Name -join ', ')
"@

    $report | Out-File "C:\Scripts\UserPermissionsAudit.txt" -Append
}
catch {
    Write-Error $_
}
