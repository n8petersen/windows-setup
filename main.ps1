$loc = Get-Location

Set-Location $loc
& "./WinCleanupScript.ps1"

Set-Location $loc
& "./ApplicationInstall.ps1"

Set-Location $loc
& "./SetupStarship.ps1"

Set-Location $loc
& "./SetupObsidian.ps1"