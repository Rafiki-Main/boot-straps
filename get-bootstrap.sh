#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════╗
# ║ 📦 L5L SYSTEM - MINIMAL BOOTSTRAP FETCHER                         ║
# ║ 🏷️ Script: get-bootstrap.sh                                       ║
# ║ 🛡️ Purpose: Download the real bootstrap script with a token       ║
# ║ 🔗 Requires: --url and --token passed as arguments                 ║
# ╚════════════════════════════════════════════════════════════════════╝

set -euo pipefail

## --- INPUT PARSING --- ##
BOOTSTRAP_URL=""
GIT_TOKEN=""
OUTPUT_FILE="l5l-vm-bootstrap.sh"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --url=*) BOOTSTRAP_URL="${1#*=}" ; shift ;;
    --token=*) GIT_TOKEN="${1#*=}" ; shift ;;
    --out=*) OUTPUT_FILE="${1#*=}" ; shift ;;
    *) echo "❌ Unknown argument: $1" >&2 ; exit 1 ;;
  esac
done

## --- VALIDATE INPUTS --- ##
if [[ -z "$BOOTSTRAP_URL" || -z "$GIT_TOKEN" ]]; then
  echo "❌ Usage: $0 --url=<bootstrap-url> --token=<gh_token> [--out=filename]" >&2
  exit 1
fi

echo "🔐 Token prefix: ${GIT_TOKEN:0:4}********"
echo "🌐 Fetching bootstrap script from:
➡️  $BOOTSTRAP_URL"

## --- DOWNLOAD THE REAL BOOTSTRAP SCRIPT --- ##
wget -q --header="Authorization: token $GIT_TOKEN" "$BOOTSTRAP_URL" -O "$OUTPUT_FILE"

if [[ ! -s "$OUTPUT_FILE" ]]; then
  echo "❌ Failed to download bootstrap script." >&2
  exit 2
fi

chmod +x "$OUTPUT_FILE"
echo "✅ Bootstrap script saved to: $OUTPUT_FILE"
echo "💡 To run it: sudo bash ./$OUTPUT_FILE"

exit 0
