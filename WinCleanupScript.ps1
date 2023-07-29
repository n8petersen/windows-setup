Write-Host "The following apps have been uninstalled:"

# 3D Viewer
Get-AppxPackage "*Microsoft.Microsoft3DViewer*" | Remove-AppxPackage
Write-Host "3D Viewer"

# Alarms
Get-AppxPackage "*Microsoft.WindowsAlarms*" | Remove-AppxPackage
Write-Host "Alarms"

# Cortana
Get-AppxPackage "*Microsoft.549981C3F5F10*" | Remove-AppxPackage
Write-Host "Cortana"

# Feedback Hub
Get-AppxPackage "*Microsoft.WindowsFeedbackHub*" | Remove-AppxPackage
Write-Host "Feedback Hub"

# Get Help
Get-AppxPackage "*Microsoft.GetHelp*" | Remove-AppxPackage
Write-Host "Get Help"

# Groove Music
Get-AppxPackage "*Microsoft.ZuneMusic*" | Remove-AppxPackage
Write-Host "Groove Music"

# Mail/Calendar
Get-AppxPackage "*microsoft.windowscommunicationsapps*" | Remove-AppxPackage
Write-Host "Mail & Calendar"

# Maps
Get-AppxPackage "*Microsoft.WindowsMaps*" | Remove-AppxPackage
Write-Host "Maps"

# Microsoft Solitaire Collection
Get-AppxPackage "*Microsoft.MicrosoftSolitaireCollection*" | Remove-AppxPackage
Write-Host "SolitaireCollection"

#Mixed Reality Portal
Get-AppxPackage "*Microsoft.MixedReality.Portal*" | Remove-AppxPackage
Write-Host "Mixed Reality Portal"

# Movies & TV
Get-AppxPackage "*Microsoft.ZuneVideo*" | Remove-AppxPackage
Write-Host "Movies & TV"

# Office
Get-AppxPackage "*Microsoft.MicrosoftOfficeHub*" | Remove-AppxPackage
Write-Host "Office"

# OneNote
Get-AppxPackage "*Microsoft.Office.OneNote*" | Remove-AppxPackage
Write-Host "OneNote"

# Paint 3D
Get-AppxPackage "*Microsoft.MSPaint*" | Remove-AppxPackage
Write-Host "Paint 3D"

# People
Get-AppxPackage "*Microsoft.People*" | Remove-AppxPackage
Write-Host "People"

# Phone Link
Get-AppxPackage "*Microsoft.YourPhone*" | Remove-AppxPackage
Write-Host "Phone Link"

# Skype
Get-AppxPackage "*Microsoft.SkypeApp*" | Remove-AppxPackage
Write-Host "Skype"

# Tips
Get-AppxPackage "*Microsoft.Getstarted*" | Remove-AppxPackage
Write-Host "Tips"

# Voice Recorder
Get-AppxPackage "*Microsoft.WindowsSoundRecorder*" | Remove-AppxPackage
Write-Host "Voice Recorder"

# Weather
Get-AppxPackage "*Microsoft.BingWeather*" | Remove-AppxPackage
Write-Host "Weather"


## Camera
$cameraConfirmation = Read-Host "Would you like to uninstall Camera? (y/n)"
if ($cameraConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.WindowsCamera*" | Remove-AppxPackage
    Write-Host "Camera"
}


## Calculator
$calcConfirmation = Read-Host "Would you like to uninstall Calculator? (y/n)"
if ($calcConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.WindowsCalculator*" | Remove-AppxPackage
    Write-Host "Calculator"
}


## Microsoft Store
$xboxConfirmation = Read-Host "Would you like to uninstall Microsoft Store? (y/n)"
if ($xboxConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.WindowsStore*" | Remove-AppxPackage
    Write-Host "Microsoft Store"
}


# OneDrive
$onedriveConfirmation = Read-Host "Would you like to uninstall OneDrive? (y/n)"
if ($onedriveConfirmation -eq 'y') {
    ps onedrive | Stop-Process -Force
    start-process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall"
    Write-Host "OneNote"
}


## Photos
$xboxConfirmation = Read-Host "Would you like to uninstall Photos? (y/n)"
if ($xboxConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.Windows.Photos*" | Remove-AppxPackage
    Write-Host "Photos"
}


## Snip & Sketch
$snipsketchConfirmation = Read-Host "Would you like to uninstall Snip & Sketch? (y/n)"
if ($snipsketchConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.ScreenSketch*" | Remove-AppxPackage
    Write-Host "Snip & Sketch"
}


## Sticky Notes
$stickynotesConfirmation = Read-Host "Would you like to uninstall Sticky Notes? (y/n)"
if ($stickynotesConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.MicrosoftStickyNotes*" | Remove-AppxPackage
    Write-Host "Sticky Notes"
}


## Xbox
$xboxConfirmation = Read-Host "Would you like to uninstall Xbox? (y/n)"
if ($xboxConfirmation -eq 'y') {
    Get-AppxPackage "*Microsoft.XboxApp*" | Remove-AppxPackage
    Write-Host "Xbox"
}
