param([int]$Port = 8765)
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$repositoryRoot = Split-Path -Parent (Split-Path -Parent $labRoot)
$localPython = Join-Path $labRoot '.venv\Scripts\python.exe'
if (Test-Path -LiteralPath $localPython) {
    & $localPython (Join-Path $labRoot 'simulator.py') serve --port $Port
} elseif (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    & wsl.exe --cd $repositoryRoot --exec .venv/bin/python tools/battle-simulator/simulator.py serve --port $Port
} else {
    throw 'Create tools/battle-simulator/.venv and install requirements.txt; see README.md.'
}
exit $LASTEXITCODE
