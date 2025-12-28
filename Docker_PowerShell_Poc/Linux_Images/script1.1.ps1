function Test-DockerInteraction {
    Write-Host "Function executed INSIDE container"
    Write-Host "PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Host "User: $env:USER"
    Write-Host "Path: $(Get-Location)"
}

# Keep container alive indefinitely.
# This loop does NOT mean 60 seconds total.
# It sleeps 60 seconds repeatedly until you stop the container.
while ($true) {
    Start-Sleep -Seconds 60
}
