i#!/usr/bin/env bash
# Re-exec under nix shell if nix/jq are missing
if ! command -v nix >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  exec nix shell nixpkgs#bash nixpkgs#jq nixpkgs#nix --command bash "$0" "$@"
fi
set -euo pipefail

FLAKE="${FLAKE:-.}"
LIMIT="${LIMIT:-75000000}"
TOP_N="${TOP_N:-30}"

HOST=""
TARGET_PATH=""
ATTR=""

usage() { echo "Usage: $0 --host HOST | --path /nix/store/... | --attr flakeAttr"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
  --host)
    HOST="$2"
    shift 2
    ;;
  --path)
    TARGET_PATH="$2"
    shift 2
    ;;
  --attr)
    ATTR="$2"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown arg: $1"
    usage
    exit 1
    ;;
  esac
done

# Resolve the target store path
if [[ -n "$TARGET_PATH" ]]; then
  TOP="$TARGET_PATH"
elif [[ -n "$HOST" ]]; then
  TOP="$(nix build "$FLAKE"#nixosConfigurations."$HOST".config.system.build.toplevel --no-link --print-out-paths)"
elif [[ -n "$ATTR" ]]; then
  TOP="$(nix build "$FLAKE"#"$ATTR" --no-link --print-out-paths)"
else
  echo "Need --host | --path | --attr" >&2
  exit 1
fi
[[ -e "$TOP" ]] || {
  echo "Path not found: $TOP" >&2
  exit 1
}

echo "Target: $TOP"

# jq program that normalizes any nix JSON shape -> array of {path,narSize}
JQ_NORM='
def norm:
  if type=="array" then .
  elif (type=="object") and has("path") then [ . ]
  elif (type=="object") then to_entries | map({path: .key, narSize: (.value.narSize // 0)})
  else [] end;
norm | map({path, narSize})
'

# 1) Top-level narSize
TOP_BYTES="$(nix path-info --json "$TOP" | jq -r "$JQ_NORM | .[0].narSize // 0")"
echo "Top-level NAR size: ${TOP_BYTES} bytes"
echo

# 2) Top N largest in closure
CLOSURE_JSON="$(nix path-info --recursive --json "$TOP")"
TOP_LINES="$(jq -r --argjson N "$TOP_N" "$JQ_NORM
  | sort_by(.narSize)
  | (if length > \$N then .[-\$N:] else . end)
  | .[] | \"\(.narSize)\t\(.path)\"" <<<"$CLOSURE_JSON")"

echo "Top ${TOP_N} by NAR size (bytes):"
if [[ -n "$TOP_LINES" ]]; then
  echo "$TOP_LINES"
else
  echo "(no entries found)"
fi
echo

# 3) Anything ≥ LIMIT
OVER_LINES="$(jq -r --argjson L "$LIMIT" "$JQ_NORM
  | map(select(.narSize >= \$L))
  | sort_by(.narSize)
  | .[] | \"\(.narSize)\t\(.path)\"" <<<"$CLOSURE_JSON")"

echo "Paths ≥ ${LIMIT} bytes:"
if [[ -n "$OVER_LINES" ]]; then
  echo "$OVER_LINES"
else
  echo "(none)"
fi
