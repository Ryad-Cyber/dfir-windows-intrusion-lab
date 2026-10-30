<#
.SYNOPSIS
    Enchaine une serie de plugins Volatility 3 de base sur une capture memoire
    et range chaque sortie dans un fichier dedie, pour accelerer la revue manuelle.

.DESCRIPTION
    Ce script ne remplace pas l'analyse manuelle : il automatise uniquement
    l'execution et le rangement des sorties. Chaque fichier genere doit ensuite
    etre revu pour en extraire les constats pertinents vers le rapport d'incident.

.PARAMETER MemoryImage
    Chemin vers la capture memoire (.raw / .mem / .vmem).

.PARAMETER OutDir
    Dossier de sortie (cree s'il n'existe pas). Par defaut : work/volatility_out

.EXAMPLE
    ./volatility_quickstart.ps1 -MemoryImage .\evidence\memory.raw -OutDir .\work\volatility_out
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MemoryImage,

    [string]$OutDir = ".\work\volatility_out"
)

if (-not (Test-Path $MemoryImage)) {
    Write-Error "Capture memoire introuvable : $MemoryImage"
    exit 1
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$plugins = @(
    "windows.info",
    "windows.pslist",
    "windows.pstree",
    "windows.cmdline",
    "windows.envars",
    "windows.netscan",
    "windows.malfind",
    "windows.filescan",
    "windows.dlllist",
    "windows.handles"
)

foreach ($plugin in $plugins) {
    $outFile = Join-Path $OutDir ("{0}.txt" -f ($plugin -replace '\.', '_'))
    Write-Host "Execution de $plugin -> $outFile"
    try {
        vol -f $MemoryImage $plugin *> $outFile
    }
    catch {
        Write-Warning "Echec sur le plugin $plugin : $_"
    }
}

Write-Host "`nTermine. Sorties disponibles dans $OutDir"
Write-Host "Etape suivante : revoir manuellement chaque fichier et reporter les constats pertinents dans le rapport d'incident."
