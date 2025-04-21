# d-sabido
# ---
# Script Name: DetectWSL.ps1
# ---
# Description:
# This script must be used along with RemediateWSL.ps1, to enable the Windows feature.
# This script will check whether the Windows Subsystem for Linux feature is enabled.
# If it is enabled, it will exit with code '0'. If it is not enabled, it will exit
# with code '1'.
# This script can be modified to check for a different Windows feature by editing
# the 'FeatureName' variable.
# ---
# Prerequisites:
# - RemediateWSL.ps1
# - Added as a 'detection' script in Intune
# ---

$FeatureName = "Microsoft-Windows-Subsystem-Linux"

if ((Get-WmiObject -query "select * from win32_optionalfeature where name = 'Microsoft-Windows-Subsystem-Linux").installState -eq "1") {
    Write-Host "$FeatureName is enabled."
    exit 0
} else {
    Write-Host "$FeatureName is not enabled."
    exit 1
}