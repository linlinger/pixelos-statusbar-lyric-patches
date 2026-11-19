#!/bin/bash
# Status bar lyric patches for PixelOS (Android 17)
# Ported from Evolution-X branch cnb.
#
# Usage: clone this repo anywhere INSIDE the Android source tree, then run:
#   git clone https://github.com/linlinger/pixelos-statusbar-lyric-patches.git
#   cd pixelos-statusbar-lyric-patches && bash apply.sh
set -e

PATCH_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$(cd "$PATCH_DIR/.." && pwd)"

apply() {
    local repo="$1" dir="$2"
    echo "==> Applying patches to $repo"
    cd "$SRC/$repo"
    if ! git am -3 "$PATCH_DIR/$dir"/*.patch; then
        echo "!! git am failed for $repo, trying git apply --reject"
        git am --abort 2>/dev/null || true
        git apply --reject "$PATCH_DIR/$dir"/*.patch
        echo "!! Resolve .rej files manually, then commit."
    fi
}

apply frameworks/base frameworks_base
apply packages/apps/Settings packages_apps_Settings

echo "All patches applied."
echo "Note: a full rebuild is required -- the exposed ticker flags must be"
echo "baked into the hidden-API metadata of the boot dex at build time."
