function Update-PowerToys {
    param (
        # editorconfig-checker-disable
        [string]$SourceURL = "https://github.com/loicreynier/igloo/raw/main/config/powertoys/configuration.dsc.yaml"
        # editorconfig-checker-enable
    )

    Write-Host -ForegroundColor DarkCyan "Updating (or installing) PowerToys..."

    $configPath = "$env:TEMP\powertoys-config.dsc.yaml"

    try {
        Invoke-RestMethod $SourceURL -OutFile $configPath
        try {
            winget configure --verbose --logs --accept-configuration-agreements "$configPath"
            Remove-Item -Path $configPath
        }
        catch {
            Write-Error "Failed to install/update PowerToys or to apply configuration. Error: $_"
        }
    }
    catch {
        Write-Error "Failed to retrieve PowerToys configuration from $SourceURL. Error: $_"
    }

}

Update-PowerToys
