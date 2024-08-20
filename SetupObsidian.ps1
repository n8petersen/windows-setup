Set-Location "~/Documents"

Write-Host "Cloning and pulling Obsidian"
if (!(Test-Path "./obsidian")) {
    git clone https://gitlab.com/n8petersen/obsidian.git
}
Set-Location "~/Documents/obsidian"
git pull

Write-Host "Cloning and pulling Obsidian School"
Set-Location "~/Documents"
if (!(Test-Path "./obsidian-school")) {
    git clone https://gitlab.com/n8petersen/obsidian-school.git
}
Set-Location "~/Documents/obsidian-school"
git pull