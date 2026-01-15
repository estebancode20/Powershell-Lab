try {
    # Get CPU load
    $cpu = (Get-Process | Measure-Object CPU -Sum).Sum

    # Get memory info
    $os = Get-CimInstance Win32_OperatingSystem
    $memUsedPercent = [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100, 2)

    # Get disk free space C:
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $diskFreePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)

    # Get first 10 services
    $services = Get-Service | Select-Object -First 10

    # Simple report
    $report = @"
Time: $(Get-Date)
CPU Load Sum: $cpu
Memory Used %: $memUsedPercent
Disk Free C %: $diskFreePercent
First 10 Services: $($services.Name -join ', ')
"@

    $report | Out-File "C:\Scripts\LocalHealthReport.txt" -Append
}
catch {
    Write-Error $_
}


# # Create the directory if it does not exist (Out-File cannot create folders)
# New-Item -Path C:\Scripts -ItemType Directory -Force
