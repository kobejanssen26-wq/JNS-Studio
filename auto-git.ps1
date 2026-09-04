$folder = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $folder

Write-Host "Git auto-sync gestart..."
Write-Host "Map: $folder"
Write-Host "Stoppen: Ctrl+C"

$lastChange = Get-Date

while ($true) {

    Start-Sleep -Seconds 5

    $changes = git status --porcelain

    if ($changes) {

        Write-Host ""
        Write-Host "Wijzigingen gevonden. Wachten op rust..."

        Start-Sleep -Seconds 5

        $changes = git status --porcelain

        if ($changes) {

            Write-Host "Wijzigingen committen..."

            git add .

            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "Auto update $timestamp"

            if ($LASTEXITCODE -eq 0) {
                Write-Host "Push naar GitHub..."
                git push

                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Klaar! GitHub is bijgewerkt."
                }
                else {
                    Write-Host "Push mislukt."
                }
            }
        }
    }
}