# Waits until ParaBank answers HTTP 200 on index.htm (Windows PowerShell version of wait-for-parabank.sh).
# Usage: .\scripts\wait-for-parabank.ps1 [-BaseUrl http://localhost:8080/parabank] [-TimeoutSeconds 120]
# On a fresh container index.htm answers 302 to initializeDB.htm until the redirect is followed:
# Invoke-WebRequest follows redirects like a browser does, which also triggers the first database initialization.

param(
    [string]$BaseUrl = $(if ($env:PARABANK_URL) { $env:PARABANK_URL } else { 'http://localhost:8080/parabank' }),
    [int]$TimeoutSeconds = $(if ($env:WAIT_TIMEOUT) { [int]$env:WAIT_TIMEOUT } else { 120 })
)

$url = $BaseUrl.TrimEnd('/') + '/index.htm'
$intervalSeconds = 2
Write-Host "Waiting for ParaBank at $url (timeout ${TimeoutSeconds}s)..."

$watch = [System.Diagnostics.Stopwatch]::StartNew()
while ($true) {
    $status = 'no response'
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
        $status = $response.StatusCode
    } catch {
        if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }
    }

    if ($status -eq 200) {
        Write-Host "ParaBank is up (HTTP 200) after $([int]$watch.Elapsed.TotalSeconds)s."
        exit 0
    }

    if ($watch.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
        [Console]::Error.WriteLine("ERROR: ParaBank did not answer HTTP 200 within ${TimeoutSeconds}s (last status: $status).")
        [Console]::Error.WriteLine('Check the container: docker compose ps / docker compose logs parabank')
        exit 1
    }

    Start-Sleep -Seconds $intervalSeconds
}
