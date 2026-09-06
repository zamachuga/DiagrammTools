#!/bin/bash
set -e

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to folder containing structurizr-lite*.war
DISTRIB_DIR="$SCRIPT_DIR/../Distrib"

# Port for the local web server (can also be passed as first argument)
PORT="${1:-8080}"

# Folder containing the workspace file (leave EMPTY to use current folder)
WORKSPACE_DIR=""

# Workspace file name
WORKSPACE_FILENAME="workspace.dsl"

# Full path to the workspace file (built from WORKSPACE_DIR + WORKSPACE_FILENAME)
WORKSPACE=""
if [ -n "$WORKSPACE_DIR" ]; then
    WORKSPACE="$WORKSPACE_DIR/$WORKSPACE_FILENAME"
fi

# ============================================================

echo "=========================================="
echo "  Structurizr Lite - Start (macOS)"
echo "=========================================="
echo

WAR_PATH=$(ls "$DISTRIB_DIR"/structurizr-lite*.war 2>/dev/null | head -1)
if [ -z "$WAR_PATH" ]; then
    echo "[ERROR] structurizr-lite*.war not found in $DISTRIB_DIR."
    echo "Run Setup/macOS/setup.sh first."
    exit 1
fi

if [ ! -f "$WAR_PATH" ]; then
    echo "[ERROR] File not found: $WAR_PATH"
    exit 1
fi

echo "[1/2] Checking Java..."
if ! command -v java >/dev/null 2>&1; then
    echo "[ERROR] Java not found."
    echo "Install Java 21: bash Setup/macOS/install-java.sh"
    exit 1
fi
echo "      Java version: $(java -version 2>&1 | head -n 1)"

if [ -n "$WORKSPACE" ] && [ ! -f "$WORKSPACE" ]; then
    echo "[ERROR] Workspace file not found: $WORKSPACE"
    exit 1
fi

echo "[2/2] Starting Structurizr Lite on port $PORT..."
echo "      Open http://localhost:$PORT in your browser"
echo "      Press Ctrl+C to stop"
echo

if [ -n "$WORKSPACE" ]; then
    java -Dserver.port="$PORT" -Dstructurizr.workspacePath="$WORKSPACE" -jar "$WAR_PATH"
else
    java -Dserver.port="$PORT" -jar "$WAR_PATH"
fi