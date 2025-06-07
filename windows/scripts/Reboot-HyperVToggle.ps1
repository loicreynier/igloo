#Requires -RunAsAdministrator
function Set-HyperV {
    If (!
    (New-Object Security.Principal.WindowsPrincipal(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )).IsInRole(
            [Security.Principal.WindowsBuiltInRole]::Administrator
        )
    ) {
        Throw "Please run this script as an administrator."
    }

    $launchType = bcdedit /enum | Select-String "hypervisorlaunchtype"

    If ($launchType -match "Auto") {
        bcdedit /set hypervisorlaunchtype off
        Write-Host "Disabling Hyper-V (fort next reboot)..."
    }
    ElseIf ($launchType -match "Off") {
        Write-Host "Enabling Hyper-V (for next reboot)..."
        bcdedit /set hypervisorlaunchtype auto
    }
    Else {
        Write-Host "Unable to determine current state of Hyper-V."
        return
    }
}

Set-HyperV
Restart-Computer -Force
