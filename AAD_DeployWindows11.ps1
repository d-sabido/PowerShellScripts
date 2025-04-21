# d-sabido
# ---
# Script Name: DeployWindows11.ps1
# Note: This script uses the AzureAD PowerShell module, which is now deprecated.
# ---
# Description:
# This script will import a .csv file, filled with device names from Entra, remove them from a Windows 10
# Entra group, and then add them to a new Entra group that deploys the Windows 11 upgrade.
# This script assumes that you have two groups to deploy - one to deploy the upgrade itself, and one to
# deploy any necessary security policies.
# ---
# Prerequisites:
# - AzureAD PowerShell module (deprecated)
# ---

# Import the AzureAD module
Import-Module AzureAD

# Connect to AzureAD
Connect-AzureAD

# Import the CSV file
$csv = "path_to_file_here"
$devices = Import-Csv -Path $csv

# Function to update device groups
function Update-DeviceGroups {
    param {
        [string]$deviceName
    }
    $device = Get-AzureADDevice -Filter "displayName eq '$deviceName'"
    if ($device) {
        $deviceId = $device.ObjectId

        # Remove "Windows 10" production group
        $groupToRemove = Get-AzureADGroup -Filter "displayName eq 'WIN10-PROD-PC'"
        if ($groupToRemove) {
            Remove-AzureADGroupMember -ObjectId $groupToRemove.ObjectId -MemberId $deviceId
            Write-Output "'$deviceName' removed from 'WIN10-PROD-PC'"
        } else {
            Write-Output "'$deviceName' is not a member of 'WIN10-PROD-PC'"
        }

        # Add "Windows 11" production/deployment group
        $groupToAdd1 = Get-AzureADGroup -Filter "displayName eq 'WIN11-PROD-PC'"
        if ($groupToAdd1) {
            Add-AzureADGroupMember -ObjectId $groupToAdd1.ObjectId -RefObjectId $deviceId
            Write-Output "'$deviceName' added to 'WIN11-PROD-PC'"
        } else {
            Write-Output "Something went wrong. Check the error messages for more details."
            Write-Output "Common issues:"
            Write-Output "- Two objects exist for one device"
        }

        # Add "Windows 11" security policies group
        $groupToAdd2 = Get-AzureADGroup -Filter "displayName eq 'WIN11-SEC-POL'"
        if ($groupToAdd2) {
            Add-AzureADGroupMember -ObjectId $groupToAdd2.ObjectId -RefObjectId $deviceId
            Write-Output "'$deviceName' added to 'WIN11-SEC-POL'"
        } else {
            Write-Output "Something went wrong. Check the error messages for more details."
            Write-Output "Common issues:"
            Write-Output "- Two objects exist for one device"
        }
    } else {
        Write-Output "Something went wrong. Check the error messages for more details."
        Write-Output "Common issues:"
        Write-Output "- '$deviceName' does not exist. Check your spelling."
    }
}

# Iterate over each device name in the CSV file and update groups accordingly
foreach ($device in $devices) {
    Update-DeviceGroups -deviceName $device.DeviceName
}

# end