# Export running processes to CSV on Desktop
try {
    $desktop = [Environment]::GetFolderPath('Desktop')

    # Select first 10 processes as example
    Get-Process | Select-Object Name, Id, CPU |
        Export-Csv "$desktop\Processes.csv" -NoTypeInformation
}
catch {
    Write-Error $_
}
