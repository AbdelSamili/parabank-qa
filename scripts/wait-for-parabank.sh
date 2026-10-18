#!/usr/bin/env bash
# Waits until ParaBank answers HTTP 200 on index.htm.
# Usage: ./scripts/wait-for-parabank.sh [base_url] [timeout_seconds]
# Defaults: http://localhost:8080/parabank, 120 s. PARABANK_URL and WAIT_TIMEOUT also work.
# On a fresh container index.htm answers 302 to initializeDB.htm until the redirect is followed:
# redirects are followed (-L) like a browser does, which also triggers the first database initialization.

set -u

BASE_URL="${1:-${PARABANK_URL:-http://localhost:8080/parabank}}"
TIMEOUT="${2:-${WAIT_TIMEOUT:-120}}"
URL="${BASE_URL%/}/index.htm"
INTERVAL=2

echo "Waiting for ParaBank at $URL (timeout ${TIMEOUT}s)..."

start=$(date +%s)
while true; do
  code=$(curl -s -L -o /dev/null -w "%{http_code}" --max-time 30 "$URL")
  if [ "$code" = "200" ]; then
    echo "ParaBank is up (HTTP 200) after $(( $(date +%s) - start ))s."
    exit 0
  fi

  elapsed=$(( $(date +%s) - start ))
  if [ "$elapsed" -ge "$TIMEOUT" ]; then
    echo "ERROR: ParaBank did not answer HTTP 200 within ${TIMEOUT}s (last status: $code)." >&2
    echo "Check the container: docker compose ps / docker compose logs parabank" >&2
    exit 1
  fi

  sleep "$INTERVAL"
done
