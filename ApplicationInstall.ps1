# Checking if current running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
    Write-Host "Please re-run in an elevated (administrator) shell."
    Exit
}

# winget ships with Windows 10 1809+ and Windows 11 via App Installer
$testwinget = Get-Command -Name winget.exe -ErrorAction SilentlyContinue
if (-not($testwinget)) {
    Write-Host "winget was not found. Install/update App Installer from the Microsoft Store, then re-run this script."
    Exit
}

# Apply the programs configuration
Write-Host "--== Installing Programs ==--"
Write-Host "--------------------------"
winget configure -f ./configuration/programs.dsc.yaml --accept-configuration-agreements --disable-interactivity

# Apply the games configuration, if desired
$installGames = Read-Host "Would you like to install Game Applications? (y/n)"
if ($installGames -eq 'y' -Or $installGames -eq 'Y') {
    Write-Host "--== Installing Games ==--"
    Write-Host "--------------------------"
    winget configure -f ./configuration/games.dsc.yaml --accept-configuration-agreements --disable-interactivity
}

# Update any existing winget packages
Write-Host "--== Updating Packages ==--"
Write-Host "---------------------------"
winget upgrade --all --accept-package-agreements --accept-source-agreements


# Install WSL
Write-Host "--== Installing WSL Distros ==--"
Write-Host "---------------------------"
wsl --install -d ubuntu-22.04 -n
wsl --install -d kali-linux -n


Write-Host "---------------------------------"
Write-Host "Finished installing and updating applications."
