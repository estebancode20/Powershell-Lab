function Test-SystemHealth {
    Write-Host "Running system health checks"

    Write-Host "PowerShell version:"
    $PSVersionTable.PSVersion

    Write-Host "Current user:"
    whoami

    Write-Host "Disk usage:"
    df -h /

    Write-Host "Environment check:"
    Get-ChildItem Env: | Sort-Object Name
}

# Keep container alive for interactive validation
while ($true) {
    Start-Sleep -Seconds 60
}


# The aim is to prove a PowerShell script works in a clean environment
# before running it on real servers.
