function Test-InternetConnection {
    param (
        [string]$TestUrl = "https://www.google.com"
    )

    try {
        $response = Invoke-WebRequest -Uri $TestUrl -UseBasicParsing -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Verbose "Internet connection is available."
            return $true
        }
        else {
            # editorconfig-checker-disable
            Write-Verbose "Internet connection is not available. Status Code: $($response.StatusCode)"
            return $false
            # editorconfig-checker-enable
        }
    }
    catch {
        Write-Verbose "Internet connection is not available. Exception: $_"
        return $false
    }
}

function Update-WindowsTerminal {
    param (
        [switch]$Preview
    )

    Write-Host -ForegroundColor DarkCyan "Updating Windows Terminal..."

    winget install --id Microsoft.WindowsTerminal --source winget

    if ($Preview) {
        winget install --id Microsoft.WindowsTerminal.Preview --source winget
    }
}

# editorconfig-checker-disable
function Update-WindowsTerminalSettings {
    param (
        [string]$SourceURL = "https://github.com/loicreynier/igloo/raw/main/config/windowsterminal/settings.json",
        [switch]$Preview
    )

    Write-Host -ForegroundColor DarkCyan "Updating/Installing Windows Terminal settings file..."

    if ($Preview) {
        $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
    }
    else {
        # $settingsPath = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
        $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    }

    if (!(Test-Path -Path $settingsPath -PathType Leaf)) {
        try {
            New-Item -Path ([System.IO.Path]::GetDirectoryName($settingsPath)) -ItemType Directory -Force
            Invoke-RestMethod -Headers @{ "Cache-Control" = "no-cache" } $SourceURL -OutFile $settingsPath
            Write-Host "Windows Terminal settings file created at '$settingsPath'"
        }
        catch {
            Write-Error "Failed to create settings file. Error: $_"
        }
    }
    else {
        try {
            Write-Host "Found existing settings file"
            Move-Item -Path $settingsPath -Destination "$settingsPath.old" -Force
            Invoke-RestMethod -Headers @{ "Cache-Control" = "no-cache" } $SourceURL -OutFile $settingsPath
            Write-Host "Settings file updated. Old profile backed-up at '$settingsPath.old'"
        }
        catch {
            Write-Error "Failed to backup and update settings file. Error: $_"
        }
    }
}
# editorconfig-checker-enable

function Install-NerdFonts {
    param (
        [string]$FontName = "CascadiaCode",
        [string]$FontDisplayName = "CaskaydiaCove NF"
        # [string]$Version = "3.2.1"
    )

    Write-Host -ForegroundColor DarkCyan "Installing Nerd Font ${FontDisplayName} (${FontName})..."

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
        if ($fontFamilies -notcontains "${FontDisplayName}") {
            # editorconfig-checker-disable
            # $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${Version}/${FontName}.zip"
            $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FontName}.zip"
            # editorconfig-checker-enable
            $zipFilePath = "$env:temp\${FontName}.zip"
            $extractPath = "$env:temp\${FontName}"

            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFileAsync((New-Object System.Uri($fontZipUrl)), $zipFilePath)

            while ($webClient.IsBusy) {
                Start-Sleep -Seconds 2
            }

            Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
            $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
            Get-ChildItem -Path $extractPath -Recurse -Filter "*.ttf" | ForEach-Object {
                If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
                    $destination.CopyHere($_.FullName, 0x10)
                }
            }

            Remove-Item -Path $extractPath -Recurse -Force
            Remove-Item -Path $zipFilePath -Force
        }
        else {
            Write-Host "Font ${FontDisplayName} already installed"
        }
    }
    catch {
        Write-Error "Failed to download or install ${FontDisplayName} font. Error: $_"
    }
}

if (Test-InternetConnection) {
    Update-WindowsTerminal -Preview
    Update-WindowsTerminalSettings # -Preview
    Install-NerdFonts -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF"
}
else {
    Write-Error "Cannot setup Windows Terminal. No internet connection."
}
