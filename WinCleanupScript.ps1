param(
    # Remove all optional apps without asking. PowerShell parameter binding
    # is case-insensitive, so both -A and -a work.
    [Alias("a")]
    [switch]$All
)

# Checking if current running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
    Write-Host "Please re-run in an elevated (administrator) shell."
    Exit
}



$RemoveAppx = (
    ("Microsoft.Microsoft3DViewer", "3D Viewer"),
    ("Microsoft.WindowsAlarms", "Alarms"),
    ("Microsoft.549981C3F5F10", "Cortana"),
    ("Microsoft.WindowsFeedbackHub", "Feedback Hub"),
    ("Microsoft.GetHelp", "Get Help"),
    ("Microsoft.ZuneMusic", "Groove Music"),
    ("microsoft.windowscommunicationsapps", "Mail & Calendar"),
    ("Microsoft.WindowsMaps", "Maps"),
    ("Microsoft.MicrosoftSolitaireCollection", "SolitaireCollection"),
    ("Microsoft.MixedReality.Portal", "Mixed Reality Portal"),
    ("Microsoft.ZuneVideo", "Movies & TV"),
    ("Microsoft.MicrosoftOfficeHub", "Office"),
    ("Microsoft.Office.OneNote", "OneNote"),
    ("Microsoft.MSPaint", "Paint 3D"),
    ("Microsoft.People", "People"),
    ("Microsoft.YourPhone", "Phone Link"),
    ("Microsoft.SkypeApp", "Skype"),
    ("Microsoft.Getstarted", "Tips"),
    ("Microsoft.WindowsSoundRecorder", "Voice Recorder"),
    ("Clipchamp.Clipchamp", "Clipchamp"),
    ("MicrosoftTeams", "Teams (classic)"),
    ("MSTeams", "Teams"),
    ("Microsoft.Todos", "Todo"),
    ("Microsoft.BingNews", "News"),
    ("Microsoft.BingWeather", "Weather"),
    ("Microsoft.Copilot", "Copilot"),
    ("Microsoft.BingSearch", "Bing Search"),
    ("Microsoft.OutlookForWindows", "Outlook (new)"),
    ("Microsoft.PowerAutomateDesktop", "Power Automate"),
    ("MicrosoftCorporationII.MicrosoftFamily", "Family Safety"),
    ("Microsoft.Ink.Handwriting", "Ink Handwriting"),
    ("MicrosoftCorporationII.QuickAssist", "Quick Assist"),
    ("Microsoft.StartExperiencesApp", "Start Experiences App"),
    ("Microsoft.DesiredStateConfiguration", "Desired State Configuration"),
    ("Microsoft.XboxIdentityProvider", "Xbox Live")
)

$OptionalAppx = (
    ("Microsoft.GamingApp", "Xbox"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungSettings1.1", "Samsung Settings"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungSecurity", "Samsung Security"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungCloudBluetoothSync", "Samsung Bluetooth Sync")
)

# Removes for every existing user profile and deprovisions so the package
# doesn't get reinstalled for new users or linger in Settings > Apps >
# Installed apps - Get-AppxPackage without -AllUsers only touches the
# current user's registration, which Settings' app list doesn't solely key off.
function Remove-BloatApp {
    param([string]$Pattern)
    Get-AppxPackage -AllUsers $Pattern -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like $Pattern } |
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
}


Write-Host "The following apps have been uninstalled:"


# Uninstall from Remove List
foreach ($app in $RemoveAppx) {
    Remove-BloatApp ("*" + $app[0] + "*")
    Write-Host $app[1]
}

# Copilot's taskbar button/feature can persist even after the app package is
# gone; this is the documented policy to fully turn it off.
# https://www.thewindowsclub.com/how-to-disable-windows-copilot-in-windows
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord
Write-Host "Copilot policy disabled (sign out or restart to fully apply)"


# Uninstall from Optional List, after asking (unless -All/-a was passed)
foreach ($app in $OptionalAppx) {
    $confirmed = $All
    if (-not $confirmed) {
        $confirmation = Read-Host "Would you like to uninstall" $app[1] "? (y/n)"
        $confirmed = ($confirmation -eq 'y' -or $confirmation -eq 'Y')
    }
    if ($confirmed) {
        Remove-BloatApp ("*" + $app[0] + "*")
        Write-Host $app[1]
    }
}


# OneDrive
$onedriveConfirmed = $All
if (-not $onedriveConfirmed) {
    $onedriveConfirmation = Read-Host "Would you like to uninstall OneDrive? (y/n)"
    $onedriveConfirmed = ($onedriveConfirmation -eq 'y' -or $onedriveConfirmation -eq 'Y')
}
if ($onedriveConfirmed) {
    Get-Process onedrive -ErrorAction SilentlyContinue | Stop-Process -Force

    # OneDriveSetup.exe's location depends on which bitness got installed:
    # 64-bit OneDrive lives under System32, 32-bit under SysWOW64.
    $oneDriveSetupCandidates = @(
        "$env:windir\System32\OneDriveSetup.exe",
        "$env:windir\SysWOW64\OneDriveSetup.exe"
    )
    $oneDriveSetup = $oneDriveSetupCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($oneDriveSetup) {
        Start-Process -FilePath $oneDriveSetup -ArgumentList "/uninstall"
        Write-Host "OneDrive"
    } else {
        Write-Host "OneDriveSetup.exe not found under System32 or SysWOW64; skipping."
    }
}

Read-Host "Press enter to exit"