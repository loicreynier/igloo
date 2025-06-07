param (
    [ValidateSet("Install", "Uninstall")]
    [string]$Action = "Install"
)
function Add-AdminShortcutFlag {
    # Source: https://stackoverflow.com/q/28997799

    Param (
        [string]$Path
    )

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20 # Set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes($Path, $bytes)
}

function Add-Shortcut {
    param (
        [string]$TargetPath,
        [string]$ShortcutPath,
        [string]$Arguments = "",
        [string]$IconLocation = "",
        [switch]$AdminFlag
    )

    $TargetPath = [System.IO.Path]::GetFullPath($TargetPath)
    $ShortcutPath = [System.IO.Path]::GetFullPath($ShortcutPath)

    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = $TargetPath

    if ($Arguments) {
        $shortcut.Arguments = $Arguments
    }

    if ($IconLocation) {
        $shortcut.IconLocation = $IconLocation
    }

    $shortcut.save()

}

function Install-Script {
    param (
        [string]$SourceUrl,
        [string]$ShortcutName,
        [switch]$AdminFlag
    )

    Write-Host -ForegroundColor DarkCyan "Installing script from '$SourceUrl'..."

    $scriptFileName = [System.IO.Path]::GetFileName($SourceUrl)
    $appDataPath = [System.Environment]::GetFolderPath("ApplicationData") # Roaming
    $scriptPath = Join-Path $appDataPath "PowerShell\Scripts"
    $scriptFullPath = Join-Path $scriptPath $scriptFileName
    $startMenuPath = [System.Environment]::GetFolderPath("StartMenu")
    $shortcutPath = Join-Path $startMenuPath "Programs\PowerShell Scripts"
    $shortcutFullPath = Join-Path $shortcutPath "$ShortcutName.lnk"

    New-Item -ItemType Directory -Force -Path $scriptPath
    New-Item -ItemType Directory -Force -Path $shortcutPath

    Invoke-WebRequest -Uri $SourceUrl -OutFile $scriptFullPath
    Add-Shortcut -TargetPath "powershell.exe" -Arguments "-File `"$scriptFullPath`"" `
        -ShortcutPath $shortcutFullPath -IconLocation "powershell.exe"
    if ($AdminFlag) {
        Add-AdminShortcutFlag -Path $shortcutFullPath
    }

    Write-Host "Script download to '$scriptFullPath'"
    Write-Host "Shortcut created at '$shortcutFullPath'"
}

function Uninstall-Script {
    param (
        [string]$ScriptFileName,
        [string]$ShortcutName
    )

    $appDataPath = [System.Environment]::GetFolderPath("ApplicationData")
    $scriptPath = Join-Path $appDataPath "PowerShell\Scripts"
    $scriptFullPath = Join-Path $scriptPath $ScriptFileName
    $startMenuPath = [System.Environment]::GetFolderPath("StartMenu")
    $shortcutPath = Join-Path $startMenuPath "Programs\PowerShell Scripts"
    $shortcutFullPath = Join-Path $shortcutPath "$ShortcutName.lnk"

    if (Test-Path $scriptFullPath) {
        Remove-Item $scriptFullPath -Force
        Write-Host "Removed script: $scriptFullPath"
    }

    if (Test-Path $shortcutFullPath) {
        Remove-Item $shortcutFullPath -Force
        Write-Host "Removed shortcut: $shortcutFullPath"
    }
}

# editorconfig-checker-disable
if ($Action -eq "Install") {
    Install-Script `
        -SourceUrl "https://raw.githubusercontent.com/loicreynier/igloo/main/windows/scripts/RestartExplorer.ps1" `
        -ShortcutName "Restart Explorer"

    Install-Script `
        -SourceUrl "https://raw.githubusercontent.com/loicreynier/igloo/main/windows/scripts/RestartToggleHyperV.ps1" `
        -ShortcutName "Restart and Toggle Hyper-V" `
        -AdminFlag
}
elseif ($Action -eq "Uninstall") {
    Uninstall-Script -ScriptFileName "RestartExplorer.ps1" -ShortcutName "Restart Explorer"
    Uninstall-Script -ScriptFileName "RestartToggleHyperV.ps1" -ShortcutName "Restart and Toggle Hyper-V"
}
