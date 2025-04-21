# d-sabido
# ---
# Script Name: RemediateWSL.ps1
# ---
# Description:
# This script must be used along with DetectWSL.ps1, to check whether WSL is already
# enabled.
# This script will enable the Windows Subsystem for Linux feature. This script
# is designed to enable the feature.
# This script can be modified to enable a different Windows feature by editing
# the 'FeatureName' variable.
# ---
# Prerequisites:
# - DetecteWSL.ps1
# - Added as a 'remediation' script in Intune
# ---

$FeatureName = "Microsoft-Windows-Subsystem-Linux"

try {
    if ((Get-WindowsOptionalFeature -Online -FeatureName $FeatureName).State -ne "Enabled") {
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -All -NoRestart
            Write-Output "Successfully enabled $FeatureName."
        } catch {
            Write-Output "Failed to enable $FeatureName - please see error message."
        } else {
            Write-Output "Feature is already enabled."
        }
    }
} catch {
    Write-Output "Something went wrong - please see error message."
}