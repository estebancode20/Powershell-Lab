# ---------------------------------------------------------------------------
# No, they are not global variables., they are automatic variable

# $PSCommandPath → automatic variable (PowerShell creates it).
# $MyInvocation → automatic variable containing execution metadata.
# $MyInvocation.MyCommand.Path / Name / InvocationName → properties inside that automatic variable.
# They exist only during script execution, not global.

# ---------------------------------------------------------------------------


# ENTRY BLOCK: execute only when the script is called by its full path
# Compares full paths
# $PSCommandPath → full path used to execute the script
# $MyInvocation.MyCommand.Path → full path of this script file

# Problem: the function runs once BEFORE any It test.
# This happens during Pester's BeforeAll {
#     . "$PSScriptRoot\..\Use-Array1.0.ps1"
# }
# Because dot-sourcing loads the script using its full path,
# the full-path comparison becomes true during BeforeAll.

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-ArrayList
}



# ENTRY BLOCK: execute only when the script is called by its name
# Compares only names, not full paths
# InvocationName = name used to run the script
# MyCommand.Name = the script’s actual file name

# Advantage: works well with Pester when using:
#     BeforeAll {
#         . "$PSScriptRoot\..\Use-Array1.0.ps1"
#     }
# because InvocationName does not match the script name during dot-sourcing.
#
# Problem: the function does NOT run with F5 (Debug) or Ctrl+F5 (Start Without Debugging)
# because VS Code changes InvocationName, so the name comparison is false.
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Use-ArrayList
}




# ENTRY BLOCK: execute only when the script is called by its full path
# Compares full paths:
#   $PSCommandPath → full path used to execute the script
#   $MyInvocation.MyCommand.Path → full path of this script file

# Problem: the function runs once BEFORE any It test.
# This happens during Pester's BeforeAll {
#     . "$PSScriptRoot\..\Use-Array1.0.ps1"
# }
# Because dot-sourcing loads the script using its full path,
# the full-path comparison becomes true during BeforeAll.
if ($MyInvocation.MyCommand.Path -eq $PSCommandPath) {
    Use-ArrayList
}

# ---------------------------------------------------------------------------

# ENTRY BLOCK: execute only when the script is run directly (not dot-sourced)
# Uses ExpectingInput to detect how the script is invoked.
#
# $MyInvocation.ExpectingInput:
#   $true  → script is being dot-sourced or expects pipeline input
#   $false → script is being executed normally (F5, Ctrl+F5, terminal)
#
# Advantage: works well with Pester when using:
#     BeforeAll {
#         . "$PSScriptRoot\..\Use-Array1.0.ps1"
#     }
# Dot-sourcing sets ExpectingInput = $true, so the function does NOT run before any It test.
# Clarification: ExpectingInput is true only when the script is part of a pipeline or dot-sourced.
# Advantage: works correctly with F5 (Debug) and Ctrl+F5 (Start Without Debugging)
# because normal execution sets ExpectingInput = $false.
#
# Limitation: when debugging directly from a Pester test file (F5 inside the test),
# VS Code executes the script before Pester runs, so ExpectingInput = $false once.
# This is expected behavior and not a Pester issue.
if (-not $MyInvocation.ExpectingInput) {
    Use-ArrayList
}
