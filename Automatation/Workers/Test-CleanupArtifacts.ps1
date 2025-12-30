try {
    # Remove old files from Windows Temp (older than 30 days)
    $daysOld = 30
    Get-ChildItem "C:\Windows\Temp" -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) } |
        Remove-Item -Force

    # Remove first 10 log files from C:\Logs (example)
    Get-ChildItem "C:\Logs" -Recurse -File -Filter *.log -ErrorAction SilentlyContinue |
        Select-Object -First 10 |
        Remove-Item -Force

    # Write simple cleanup note
    "Cleanup executed at $(Get-Date)" | Out-File "C:\Scripts\CleanupReport.txt" -Append
}
catch {
    Write-Error $_
}
