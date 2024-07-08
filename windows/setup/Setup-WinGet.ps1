function Update-Winget {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $releasesURL = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
    $releases = Invoke-RestMethod -uri $releasesURL
    $latestRelease = $releases.assets
    | Where-Object { $_.browser_download_url.EndsWith('msixbundle') }
    | Select-Object -First 1

    Write-Host "Installing WinGet from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}

if (!(Get-AppPackage -name 'Microsoft.DesktopAppInstaller')) {
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
    Update-Winget
}
else {
    $doUpdate = Read-Host "WinGet is already installed. Update to latest release? (Y/n)"
    if ($doUpdate -match '^(Y|y)?$') {
        Update-Winget
    }
}
