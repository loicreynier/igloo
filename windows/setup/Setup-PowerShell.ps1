function Test-InternetConnection {
    param (
        [string]$TestUrl = "https://www.google.com"
    )

    try {
        $response = Invoke-WebRequest -Uri $TestUrl -UseBasicParsing -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Verbose "Internet connection is available."
            return $true
        } else {
            # editorconfig-checker-disable
            Write-Verbose "Internet connection is not available. Status Code: $($response.StatusCode)"
            return $false
            # editorconfig-checker-enable
        }
    } catch {
        Write-Verbose "Internet connection is not available. Exception: $_"
        return $false
    }
}

function Update-PowerShell {
    param (
        [switch]$Preview
    )

    Write-Host "Updating PowerShell..."

    winget install --id Microsoft.PowerShell --source winget
    if ($Preview) {
        winget install --id Microsoft.PowerShell.Preview --source winget
    }
}

function Update-Profile {
    param (
        [string]$URL
    )

    if (-not $URL) {
        # editorconfig-checker-disable
        $URL = "https://github.com/loicreynier/igloo/raw/main/config/powershell/Microsoft.PowerShell_profile.ps1"
        # editorconfig-checker-enable
    }

    Write-Host "Updating PowerShell profile..."

    if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
        try {
            New-Item -Path ([System.IO.Path]::GetDirectoryName($PROFILE)) -ItemType Directory -Force
            Invoke-RestMethod $URL -OutFile $PROFILE
            Write-Host "PowerShell profile created at '$PROFILE'"
        }
        catch {
            Write-Error "Failed to create the PowerShell profile. Error: $_"
        }
    }
    else {
        try {
            Write-Host "Found existing profile"
            Move-Item -Path $PROFILE -Destination "$PROFILE.old" -Force
            Invoke-RestMethod $URL -OutFile $PROFILE
            Write-Host "PowerShell profile updated. Old profile backed-up at '$PROFILE.old'"
        }
        catch {
            Write-Error "Failed to backup and update PowerShell profile. Error: $_"
        }
    }
}

if (Test-InternetConnection) {
    Update-PowerShell -Preview
    Update-Profile
} else {
    Write-Error "Cannot setup PowerShell. No internet connection."
}
