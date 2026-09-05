# Windows Server Backup and Recovery Configuration


# Requires Windows Server Backup feature
Install-WindowsFeature Windows-Server-Backup


# 1. Backup Scope


# Volume to include in the scheduled backup
$BackupVolume = "C:"

# Include all critical volumes required for Windows recovery
$IncludeCriticalVolumes = $true


# 2. Backup Method


# Windows Server Backup uses block-level backup.
#
# wbadmin does not provide a parameter to select:
# wbadmin = Windows Backup Administration
# Command-line tool for managing Windows Server Backup and recovery.

# Full / Incremental / Differential.
#
# The backup scope is controlled by -include and -allCritical.


# 3. Schedule


# Daily backup at 11:00 PM
$BackupTime = "23:00"


# 4. Destination


$BackupTarget = "E:"

if (-not (Test-Path $BackupTarget)) {
    Write-Error "Backup destination does not exist: $BackupTarget"
    exit 1
}


# 5. Storage Management


# Windows Server Backup automatically manages backup versions
# according to available space on the backup destination.
#
# There is no direct -RetentionDays parameter in wbadmin.


# 6. System State


# System State includes components such as:
# Registry, boot files, AD DS, SYSVOL, and other system components.

$BackupSystemState = $true

if ($BackupSystemState) {
    wbadmin start systemstatebackup `
        -backupTarget:$BackupTarget `
        -quiet
}


# 7. VSS


# VSS = Volume Shadow Copy Service.
# Windows Server Backup uses VSS to create consistent
# point-in-time copies during backup operations.

$VSSService = Get-Service VSS

if ($VSSService.Status -ne "Running") {
    Start-Service VSS
}


# 8. Backup Verification


# Display available backup versions
wbadmin get versions

# Display backup status
wbadmin get status

# Review Windows Server Backup events
Get-WinEvent `
    -LogName "Microsoft-Windows-Backup/Operational" `
    -MaxEvents 20


# 9. Recovery Type


# Supported recovery operations include:
# File recovery
# System State recovery
# Critical volume recovery
# Full system recovery

wbadmin get versions

# File recovery example:
# wbadmin start recovery `
#     -version:<Version> `
#     -itemType:File `
#     -items:C:\Test\File.txt

# System State recovery example:
# wbadmin start systemstaterecovery `
#     -version:<Version>


# 10. Recovery Environment


# Windows Recovery Environment (WinRE)

reagentc /info

# Enable WinRE if required
reagentc /enable


# 11. Recovery Testing


# Recovery testing should verify that backup data
# can actually be restored.

# Example test recovery of a non-critical file:
#
# wbadmin start recovery `
#     -version:<Version> `
#     -itemType:File `
#     -items:C:\Test\File.txt `
#     -recoveryTarget:C:\RecoveryTest `
#     -overwrite:No `
#     -quiet
#
# Verify the restored file:
#
# Test-Path "C:\RecoveryTest\File.txt"


# Scheduled Backup


if ($IncludeCriticalVolumes) {

    wbadmin enable backup `
        -addtarget:$BackupTarget `
        -schedule:$BackupTime `
        -include:$BackupVolume `
        -allCritical `
        -quiet

}
else {

    wbadmin enable backup `
        -addtarget:$BackupTarget `
        -schedule:$BackupTime `
        -include:$BackupVolume `
        -quiet

}


# Final Verification


wbadmin get disks
wbadmin get status
wbadmin get versions