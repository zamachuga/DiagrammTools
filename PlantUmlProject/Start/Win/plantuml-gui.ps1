$distrib = Join-Path $PSScriptRoot "..\..\Distrib"
$jar = Get-ChildItem -Path $distrib -Filter "plantuml*.jar" | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty Name
if (-not $jar) {
    Write-Host "plantuml*.jar not found in Distrib. Run Setup\Win\setup.cmd first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Starting PlantUML GUI..." -ForegroundColor Green
java -jar (Join-Path $distrib $jar) -gui
Read-Host "Press Enter to exit"