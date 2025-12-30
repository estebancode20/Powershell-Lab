# Export last 20 system events to CSV on Desktop
try {
    $desktop = [Environment]::GetFolderPath('Desktop')

    Get-EventLog -LogName System -Newest 20 |
        Select-Object TimeGenerated, EntryType, Source, EventID |
        Export-Csv "$desktop\SystemEvents.csv" -NoTypeInformation
}
catch {
    Write-Error $_
}

