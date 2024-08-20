## Setup temp directory

New-Item -Path "~" -Name "Temp" -ItemType "Directory"
Set-Location "~/Temp"

## Download Nerd Font CaskaydiaMono
Invoke-WebRequest "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaMono.zip" -OutFile CascadiaMono.zip
Expand-Archive -Path ".\CascadiaMono.zip" -DestinationPath ".\CascadiaMono"

## Install the font(s)
Set-Location "./CascadiaMono"
