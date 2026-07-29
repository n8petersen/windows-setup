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
    ("Microsoft.StartExperiencesApp", "Start Experiences App")
)

$OptionalAppx = (
    ("Microsoft.WindowsCamera", "Camera"),
    ("Microsoft.WindowsCalculator", "Calculator"),
    ("Microsoft.Windows.Photos", "Photos"),
    ("Microsoft.ScreenSketch", "Snip & Sketch"),
    ("Microsoft.MicrosoftStickyNotes", "Sticky Notes"),
    ("Microsoft.GamingApp", "Xbox"),
    ("Microsoft.XboxIdentityProvider", "Xbox Live"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungSettings1.1", "Samsung Settings"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungSecurity", "Samsung Security"),
    ("SAMSUNGELECTRONICSCO.LTD.SamsungCloudBluetoothSync", "Samsung Bluetooth Sync")
)


Write-Host "The following apps have been uninstalled:"


# Uninstall from Remove List
foreach ($app in $RemoveAppx) {
    $app_wildcards = "*" + $app[0] + "*"
    Get-AppxPackage $app_wildcards | Remove-AppxPackage
    Write-Host $app[1]
}


# Uninstall from Optional List, after asking
foreach ($app in $OptionalAppx) {
    $confirmation = Read-Host "Would you like to uninstall" $app[1] "? (y/n)"
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        $app_wildcards = "*" + $app[0] + "*"
        Get-AppxPackage $app_wildcards | Remove-AppxPackage
        Write-Host $app[1]
    }
}


# OneDrive
$onedriveConfirmation = Read-Host "Would you like to uninstall OneDrive? (y/n)"
if ($onedriveConfirmation -eq 'y' -or $onedriveConfirmation -eq 'Y') {
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