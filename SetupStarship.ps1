function Install-Fonts {
    ## Setup temp directory
    if (!(Test-Path "~\Temp")) {
        New-Item -Path "~" -Name "Temp" -ItemType "Directory" | Out-Null
    }
    Set-Location "~\Temp"

    ## Download Nerd Font CaskaydiaMono
    if (!(Test-Path "~\Temp\CascadiaMono.zip")) {
        Invoke-WebRequest "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaMono.zip" -OutFile CascadiaMono.zip
    } else {
        if (Test-Path "~\Temp\CascadiaMono") {
            Remove-Item -Recurse "~\Temp\CascadiaMono"
        }
    }
    Expand-Archive -Path ".\CascadiaMono.zip" -DestinationPath ".\CascadiaMono"

    ## Install the font(s)
    Set-Location "~\Temp\CascadiaMono"
    $fontsDir = "$env:windir\Fonts"
    $files = Get-ChildItem | Where-Object -Property Extension -eq ".ttf"
    foreach ($file in $files) {
        $fontFileName = [System.IO.Path]::GetFileName($file)
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        $fontName = $file.BaseName
        $installed = $FALSE
        if (!(Test-Path "$fontsDir\$fontFileName")) {
            Copy-Item -Path $file -Destination $fontsDir
            $installed = $TRUE
        }
        if (!(Get-ItemProperty -Path $regPath -Name $fontName -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $regPath -Name $fontName -Value $fontFileName -PropertyType String | Out-Null
            $installed = $TRUE
        }

        if ($installed) {
            Write-Host "$fontName installed"
        } else {
            Write-Host "$fontName was already installed"
        }
    }
}

## Add Starship startup to PowerShell Profile
function Set-Starship {
    if (!(Test-Path "~\Documents\PowerShell")) {
        New-Item -Path "~\Documents\" -Name "PowerShell" -Type "Directory" | Out-Null
    }
    if (!(Test-Path "~\Documents\WindowsPowerShell")) {
        New-Item -Path "~\Documents\" -Name "WindowsPowerShell" -Type "Directory" | Out-Null
    }
    Set-Content -Path "~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Value "Invoke-Expression (&starship init powershell)"
    Set-Content -Path "~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Value "Invoke-Expression (&starship init powershell)"
    Add-Content -Path "~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Value "`$ENV:STARSHIP_CONFIG = '$HOME\.config\starship.toml'"
    Add-Content -Path "~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Value "`$ENV:STARSHIP_CONFIG = '$HOME\.config\starship.toml'"

    if (!(Test-Path "~\.config")) {
        New-Item -Path "~" -Name ".config" -Type "Directory" | Out-Null
    }
    Set-Location "~\.config"
    Invoke-WebRequest "https://starship.rs/presets/toml/gruvbox-rainbow.toml" -OutFile ".\gruvbox-rainbow.toml"
    Get-Content ".\gruvbox-rainbow.toml" | Set-Content ".\starship.toml"
    Write-Host "Make sure to update your apps to use CaskaydiaMono!"
}

## Remove Temp Directory
function Invoke-Cleanup {
    Set-Location "~"
    Remove-Item -Recurse "~\Temp"
}

Install-Fonts
Set-Starship
Invoke-Cleanup