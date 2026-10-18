#!/usr/bin/env bash
# Resets the ParaBank database to its known initial state:
#   POST services/bank/cleanDB, then POST services/bank/initializeDB (both answer 204 No Content).
# Endpoints and HTTP methods checked against the WADL of the local instance (services/bank?_wadl).
# Usage: ./scripts/reset-db.sh [base_url]   (default: http://localhost:8080/parabank, or PARABANK_URL)

set -u

BASE_URL="${1:-${PARABANK_URL:-http://localhost:8080/parabank}}"
API="${BASE_URL%/}/services/bank"

call() {
  local name="$1"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 -X POST "$API/$name")
  if [ "$code" = "204" ] || [ "$code" = "200" ]; then
    echo "  $name: OK (HTTP $code)"
  else
    echo "ERROR: $name failed (HTTP $code) on $API/$name" >&2
    exit 1
  fi
}

echo "Resetting ParaBank database at $API"
call cleanDB
call initializeDB
echo "Database reset done."
