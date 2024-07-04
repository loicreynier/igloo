# -- Prologue --------------------------------------------------------------------------------------

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell version is older than 7.0. Profile will not load"
    Exit
}

$env:POWERSHELL_TELEMETRY_OPTOUT = 1

# -- Utility functions -----------------------------------------------------------------------------

function Get-LinuxDistribution {
    <#
    .SYNOPSIS
    Retrieves the Linux distribution information from the '/etc/os-release' file

    .DESCRIPTION
    The Get-LinuxDistribution function reads and parses the '/etc/os-release' file,
    which contains identification data for most modern Linux distributions.
    It returns a dictionary-like object containing the key-value pairs from the file.

    .EXAMPLE
    $linuxDistroInfo = Get-LinuxDistribution
    if ($null -ne $linuxDistroInfo) {
        $linuxDistro = $linuxDistroInfo['NAME']
        Write-Host "Detected Linux Distribution: $linuxDistro"
    } else {
        Write-Host "Linux distribution not detected"
    }

    .NOTES
    The function will throw an error if the '/etc/os-release' file is not found.

    .LINK
    https://www.freedesktop.org/software/systemd/man/os-release.html
    #>
    $info = $null

    if (Test-Path -Path "/etc/os-release") {
        $osRelease = Get-Content -Path "/etc/os-release" | ForEach-Object {
            $key, $value = $_ -split '='
            $key = $key.Trim()
            $value = $value.Trim('"').Trim()
            [PSCustomObject]@{ Key = $key; Value = $value }
        }

        $osReleaseDict = @{}
        foreach ($item in $osRelease) {
            $osReleaseDict[$item.Key] = $item.Value
        }
        $info = $osReleaseDict
    }
    else {
        throw "Cannot determine Linux distribution: '/etc/os-release' not found."
    }

    return $info
}

function Test-GitHubConnection {
    param (
        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    return Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds $TimeoutSeconds
}

function Update-Profile {
    if (-not $(Test-GitHubConnection -TimeoutSeconds 2)) {
        Write-Host -ForegroundColor `
            "Skipping profile update check: 'github.com' not responding within 2 seconds"
        return
    }

    $tempPath = "$env:temp/Microsoft.PowerShell_profile.ps1"

    try {
        $repo = "loicreynier/igloo"
        $branch = "main"
        $path = "config/powershell/Microsoft.PowerShell_profile.ps1"
        $url = "https://raw.githubusercontent.com/$repo/$branch/$path"
        $oldHash = Get-FileHash $PROFILE
        Invoke-RestMethod $url -OutFile $tempPath
        $newHash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
        if ($newHash.Hash -ne $oldHash.Hash) {
            $updateConfirmation = Read-Host `
                "A new profile update is available. Do you want to update the profile? (Y/n)"
            if ($updateConfirmation -match '^(Y|y)?$') {
                Copy-Item -Path $tempPath -Destination $PROFILE -Force
                Write-Host -ForegroundColor DarkCyan `
                    "Profile has been updated. Restart shell to reflect changes"
            }
            else {
                Write-Host "Profile update canceled by user"
            }
        }
    }
    catch {
        Write-Error "Unable to check for `$profile updates. Error: $_"
    }
    finally {
        Remove-Item $tempPath -ErrorAction SilentlyContinue
    }
}

function Update-PowerShell {
    if (-not $(Test-GitHubConnection -TimeoutSeconds 2)) {
        Write-Host "Skipping profile update check: 'github.com' not responding within 2 seconds"
        return
    }

    try {
        Write-Host -ForegroundColor DarkCyan "Checking for PowerShell updates..."
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        if ($currentVersion -lt $latestVersion) {
            $updateNeeded = $true
        }

        if ($updateNeeded) {
            Write-Host -ForegroundColor DarkCyan "Updating PowerShell..."
            winget upgrade "Microsoft.PowerShell" `
                --accept-source-agreements `
                --accept-package-agreements
            Write-Host "PowerShell has been updated. Restart shell to reflect changes"
        }
        else {
            Write-Host "PowerShell is up to date"
        }
    }
    catch {
        Write-Error "Failed to update PowerShell. Error: $_"
    }
}

function Install-ModuleIfNotExists {
    param (
        [string]$Name
    )

    $installedModule = Get-InstalledModule -Name $Name -ErrorAction SilentlyContinue

    if (-not $installedModule) {
        Write-Host "Module '$Name' is not installed. Installing..."
        try {
            Install-Module -Name $Name -Force -Scope CurrentUser -ErrorAction Stop
            Write-Host "Module '$Name' installed successfully."
        }
        catch {
            Write-Error "Failed to install module '$Name'. Error: $_"
        }
    }
}

# -- Configuration functions -----------------------------------------------------------------------

function Initialize-Shell {
    if ($IsWindows) {
        Set-PSReadLineOption -EditMode Emacs
        Initialize-ShellFzf
    }

    Initialize-ShellZoxide
    Initialize-ShellStarship
}

function Initialize-ShellFzf {
    function Set-FzfOptions {
        Install-ModuleIfNotExists -Name PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    }

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        Set-FzfOptions
    }
    elseif ($IsWindows) {
        Write-Host "fzf command not found. Attempting to install via WinGet..."
        try {
            winget install -e --id junegunn.fzf --source winget
            Write-Host "fzf installed successfully. Initializing..."
            Set-FzfOptions
        }
        catch {
            Write-Error "Failed to install fzf. Error: $_"
        }
    }
}

function Initialize-ShellZoxide {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    }
    elseif ($IsWindows) {
        Write-Host "zoxide command not found. Attempting to install via WinGet..."
        try {
            winget install -e --id ajeetdsouza.zoxide --source winget
            Write-Host "zoxide installed successfully. Initializing..."
            Invoke-Expression (& { (zoxide init powershell | Out-String) })
        }
        catch {
            Write-Error "Failed to install zoxide. Error: $_"
        }
    }
}

function Initialize-ShellStarship {
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Invoke-Expression (& starship init powershell)
    }
    elseif ($IsWindows) {
        Write-Host "Starship command not found. Attempting to install via WinGet..."
        try {
            winget install -e --id Starship.Starship --source winget
            Write-Host "Starship installed successfully. Initializing..."
            Invoke-Expression (& starship init powershell)
        }
        catch {
            Write-Error "Failed to install Starship. Error: $_"
        }
    }
}

function Invoke-LinuxConfig {
    try {
        $linuxDistroInfo = Get-LinuxDistribution
        $linuxDistro = $linuxDistroInfo['NAME']
        Write-Host "Detected Linux Distribution: $linuxDistro"

        switch ($linuxDistro) {
            "NixOS" {
                Write-Host -ForegroundColor DarkCyan "Setting up for NixOS..."
                Invoke-LinuxConfigNixOS
            }
            default {
                Write-Host -ForegroundColor DarkCyan "Setting up for default Linux distro..."
                Invoke-LinuxConfigDefault
            }
        }
    }
    catch {
        Write-Host "Error detecting Linux distribution: $_"
    }
}

function Invoke-LinuxConfigNixOS {
    Initialize-Shell
}

function Invoke-LinuxConfigDefault {
    Update-Profile
    Initialize-Shell
}

function Invoke-WindowsConfig {
    Write-Host -ForegroundColor DarkCyan "Setting up for Windows..."
    Update-PowerShell
    Update-Profile
    Initialize-Shell
}

# -- Actual configuration --------------------------------------------------------------------------

if ($IsWindows) { Invoke-WindowsConfig }
elseif ($IsLinux) { Invoke-LinuxConfig }
else { Write-Host "Unknown platform" }

function Invoke-ProfileReload {
    . $PROFILE
}
# Reloading is a bad idea because of aliases...
New-Alias -Name reload -Value Invoke-ProfileReload

function Get-PathElements {
    if ($IsLinux) { $delim = ':' }
    else { $delim = ";" }

    $env:PATH -split $delim | ForEach-Object {
        Write-Output $_
    }
}
New-Alias -Name path -Value Get-PathElements

function Invoke-WinUtil {
    $ctUrl = "https://christitus.com/win"
    $ghUrl = "https://github.com/ChrisTitusTech/winutil/releases/latest/download/winutil.ps1"
    try {
        Invoke-Expression (Invoke-RestMethod -Uri $ctUrl)
    }
    catch {
        Write-Warning "Failed to invoke WinUtil from 'christitus.com', trying from GitHub..."
        try {
            Invoke-Expression (Invoke-RestMethod -Uri $ghUrl)
        }
        catch {
            Write-Error "Failed to invoke WinUtil from GitHub. Error: $_"
        }
    }
}
New-Alias -Name winutil -Value Invoke-WinUtil
