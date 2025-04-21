# Windows Subsystem for Linux - Managed by Intune
These two scripts are designed to assist with WSL deployment via Intune.

## Requirements
In order to deploy Windows Subsystem for Linux via Entra groups, the following must be configured:
- Group
    - Create an Entra group appropriately named for this deployment
- Application
    - This assumes that you will be pushing Ubuntu to the end-user's device.
    - To do this, create a new Application in the Intune admin center
    - Microsoft Store App (new) - Ubuntu
    - Required install assigned to the group you created beforehand
- Detection Script
    - DetectWSL.ps1
- Remediation Script
    - RemediateWSL.ps1

## Use/Behaviour
Ensure that you have all requirements listed above.

The group, when assigned to the user, will enable the Windows Subsystem for Linux feature
and push the Ubuntu distribution to the end-user's device. Keep in mind that enabling the
feature requires a reboot, so the user will not be able to launch the Ubuntu distribution
until a restart is performed.