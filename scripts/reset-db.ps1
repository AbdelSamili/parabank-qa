# Resets the ParaBank database (Windows PowerShell version of reset-db.sh):
#   POST services/bank/cleanDB, then POST services/bank/initializeDB (both answer 204 No Content).
# Usage: .\scripts\reset-db.ps1 [-BaseUrl http://localhost:8080/parabank]

param(
    [string]$BaseUrl = $(if ($env:PARABANK_URL) { $env:PARABANK_URL } else { 'http://localhost:8080/parabank' })
)

$api = $BaseUrl.TrimEnd('/') + '/services/bank'

function Invoke-DbService([string]$name) {
    $status = 'no response'
    try {
        $response = Invoke-WebRequest -Uri "$api/$name" -Method Post -UseBasicParsing -TimeoutSec 30
        $status = $response.StatusCode
    } catch {
        if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }
    }

    if ($status -eq 204 -or $status -eq 200) {
        Write-Host "  ${name}: OK (HTTP $status)"
    } else {
        [Console]::Error.WriteLine("ERROR: $name failed (HTTP $status) on $api/$name")
        exit 1
    }
}

Write-Host "Resetting ParaBank database at $api"
Invoke-DbService 'cleanDB'
Invoke-DbService 'initializeDB'
Write-Host 'Database reset done.'
