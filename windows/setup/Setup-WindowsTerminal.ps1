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

    Write-Host "Updating Windows Terminal..."

    winget install --id Microsoft.WindowsTerminal --source winget

    if ($Preview) {
        winget install --id Microsoft.WindowsTerminal.Preview --source winget
    }
}

function Install-NerdFonts {
    param (
        [string]$FontName = "CascadiaCode",
        [string]$FontDisplayName = "CaskaydiaCove NF",
        [string]$Version = "3.2.1"
    )

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
        if ($fontFamilies -notcontains "${FontDisplayName}") {
            # editorconfig-checker-disable
            $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${Version}/${FontName}.zip"
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
        } else {
            Write-Host "Font ${FontDisplayName} already installed"
        }
    }
    catch {
        Write-Error "Failed to download or install ${FontDisplayName} font. Error: $_"
    }
}

if (Test-InternetConnection) {
    Update-WindowsTerminal -Preview
    Install-NerdFonts -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF"
}
else {
    Write-Error "Cannot setup Windows Terminal. No internet connection."
}
