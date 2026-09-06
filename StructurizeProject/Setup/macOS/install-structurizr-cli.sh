#!/bin/bash
# Structurizr CLI - Installation (macOS)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZIP="$SCRIPT_DIR/../../Distrib/structurizr-cli.zip"
DEST="$SCRIPT_DIR/../../Distrib/structurizr-cli"

echo "=========================================="
echo "  Structurizr CLI - Installation (macOS)"
echo "=========================================="
echo

if [ ! -f "$ZIP" ]; then
    echo "[ERROR] File not found: $ZIP"
    echo "Place structurizr-cli.zip in the Distrib folder."
    exit 1
fi

echo "[1/3] Checking Java..."
if ! command -v java >/dev/null 2>&1; then
    echo "[ERROR] Java not found."
    echo "Install Java 21: bash Setup/macOS/install-java.sh"
    exit 1
fi
echo "      Java version: $(java -version 2>&1 | head -n 1)"

echo "[2/3] Extracting $ZIP..."
if [ -d "$DEST" ]; then
    echo "      Target folder already exists, removing: $DEST"
    rm -rf "$DEST"
fi
mkdir -p "$DEST"
unzip -q "$ZIP" -d "$DEST"
chmod +x "$DEST/structurizr.sh"

if [ ! -f "$DEST/structurizr.sh" ]; then
    echo "[ERROR] structurizr.sh not found after extraction."
    exit 1
fi

echo "[3/3] Verifying installation..."
"$DEST/structurizr.sh" version

echo
echo "=========================================="
echo "  Installation complete."
echo "  Usage (from any folder):"
echo "    $DEST/structurizr.sh --help"
echo "  Example:"
echo "    $DEST/structurizr.sh pull -w workspace.dsl -r remote"
echo "=========================================="
