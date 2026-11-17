#!/usr/bin/env bash
#
# Publish the built data zip as a GitHub release.
#
# Usage:
#   ./make_release.sh              # version read from _targets.R
#   ./make_release.sh 2026.7.16    # explicit version override
#
# Run AFTER tar_make() has built release/epi_swa_data_library.zip.
#
# Requires the GitHub CLI (https://cli.github.com) and a one-time
# `gh auth login`.

set -euo pipefail

REPO="Economic/data"
ZIP="release/epi_swa_data_library.zip"

# Version: first argument, or the data_release_version value in _targets.R.
VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  VERSION=$(sed -nE 's/.*data_release_version[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' _targets.R | head -1)
fi

if [[ -z "$VERSION" ]]; then
  echo "Error: could not determine version (not passed, and not found in _targets.R)." >&2
  exit 1
fi

if [[ ! -f "$ZIP" ]]; then
  echo "Error: $ZIP not found. Run tar_make() first." >&2
  exit 1
fi

echo "Publishing $ZIP to $REPO release $VERSION"

if gh release view "$VERSION" --repo "$REPO" >/dev/null 2>&1; then
  echo "Release $VERSION already exists; uploading asset (clobbering if present)."
  gh release upload "$VERSION" "$ZIP" --repo "$REPO" --clobber
else
  echo "Creating release $VERSION and uploading asset."
  gh release create "$VERSION" "$ZIP" --repo "$REPO" --title "$VERSION" --notes ""
fi

echo "Done: https://github.com/$REPO/releases/tag/$VERSION"
