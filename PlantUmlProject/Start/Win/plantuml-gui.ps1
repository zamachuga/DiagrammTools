# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
$DistribDir = Join-Path $PSScriptRoot "..\..\Distrib"

# Full path to .puml file or folder to open (leave empty to use default)
$PumlFile = ""

# ============================================================

$jar = Get-ChildItem -Path $DistribDir -Filter "plantuml*.jar" | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty Name
if (-not $jar) {
    Write-Host "plantuml*.jar not found in $DistribDir. Run Setup\Win\setup.cmd first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$jarPath = Join-Path $DistribDir $jar
Write-Host "Starting PlantUML GUI..." -ForegroundColor Green
if ($PumlFile) {
    java -jar $jarPath -gui $PumlFile
} else {
    java -jar $jarPath -gui
}
Read-Host "Press Enter to exit"