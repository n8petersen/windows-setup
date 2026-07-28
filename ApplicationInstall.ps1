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

# Parse programs.txt into array, and install
Write-Host "--== Installing Programs ==--"
Write-Host "--------------------------"
[string[]]$appArray = Get-Content -Path './InstallPrograms.txt'
foreach ($app in $appArray) {
    if ($app -notmatch '((#|\/\/).*)' -and $app -ne "") {
        Write-Host "Installing $app"
        winget install --id $app -e --source winget --accept-package-agreements --accept-source-agreements
    }
}

# Parse games.txt into array, and install, if desired
$installGames = Read-Host "Would you like to install Game Applications? (y/n)"
if ($installGames -eq 'y' -Or $installGames -eq 'Y') {
    Write-Host "--== Installing Games ==--"
    Write-Host "--------------------------"
    [string[]]$gamesArray = Get-Content -Path './InstallGames.txt'
    foreach ($game in $gamesArray) {
        if ($game -notmatch '((#|\/\/).*)' -and $game -ne "") {
            Write-Host "Installing $game"
            winget install --id $game -e --source winget --accept-package-agreements --accept-source-agreements
        }
    }
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
