# Export services to CSV on Desktop
try {
    $desktop = [Environment]::GetFolderPath('Desktop')

    # Select first 10 services as example
    Get-Service | Select-Object Name, Status, StartType |
        Export-Csv "$desktop\Services.csv" -NoTypeInformation
}
catch {
    Write-Error $_
}
