#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "Starting Sena FarmERP v7.0 local server on http://localhost:8080"
python3 -m http.server 8080
