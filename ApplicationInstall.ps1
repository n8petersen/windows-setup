# Checking if current running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
    Write-Host "Please re-run in an elevated (administrator) shell."
    Exit
}

# Install Chocolatey
$testchoco = powershell choco -v
if (-not($testchoco)) {
    Write-Output "Seems Chocolatey is not installed, installing now."
    Write-Host "----------------------------------------------------"
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else {
    Write-Output "Chocolatey Version $testchoco is already installed, skipping Chocolatey Install."
    Write-Host "----------------------------------------------------------------------------------"
}

# Parse programs.txt into array, and install
Write-Host "--== Installing Programs ==--"
Write-Host "--------------------------"
[string[]]$appArray = Get-Content -Path './InstallPrograms.txt'
foreach ($app in $appArray) {
    # Write-Host "choco install $app -y"
    choco install $app -y
}

# Parse games.txt into array, and install, if desired
$installGames = Read-Host "Would you like to install Game Applications? (y/n)"
if ($installGames -eq 'y' -Or $installGames -eq 'Y') {
    Write-Host "--== Installing Games ==--"
    Write-Host "--------------------------"
    [string[]]$gamesArray = Get-Content -Path './InstallGames.txt'
    foreach ($game in $gamesArray) {
        # Write-Host "choco install $game -y"
        choco install $game -y
    }
}

# Update any existing choco packages
Write-Host "--== Updating Packages ==--"
Write-Host "---------------------------"
choco upgrade all -y

    
Write-Host "---------------------------------"
Write-Host "Finished installing and updating applications."



