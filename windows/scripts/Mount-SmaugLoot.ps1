param(
    [ValidateSet("Mount", "Unmount")]
    [string]$Action = "Mount"
)

$drive = '\\.\PHYSICALDRIVE2'
$partition = 1
$mountName = 'loot'
$fsType = 'ext4'

if ($Action -eq "Mount") {
    $cmd = "wsl --mount `"$drive`" --partition $partition --name $mountName --type $fsType"
}
elseif ($Action -eq "Unmount") {
    $cmd = "wsl --unmount `"$drive`""
}

Write-Host "Running: $cmd" -ForegroundColor Cyan
Invoke-Expression $cmd
