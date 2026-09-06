#!/bin/bash
# Structurizr Lite - Start (macOS)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find structurizr-lite*.war dynamically
WAR=$(ls "$SCRIPT_DIR/../Distrib"/structurizr-lite*.war 2>/dev/null | head -1)
if [ -z "$WAR" ]; then
    echo "[ERROR] structurizr-lite*.war not found in Distrib."
    echo "Run Setup/macOS/setup.sh first."
    exit 1
fi

# Port for the local web server
PORT="${1:-8080}"

# Path to the diagram file workspace.dsl (absolute or relative to this script).
# Leave EMPTY to let Structurizr Lite find "workspace.dsl" in the current folder.
WORKSPACE=""

# ============================================================

echo "=========================================="
echo "  Structurizr Lite - Start (macOS)"
echo "=========================================="
echo

if [ ! -f "$WAR" ]; then
    echo "[ERROR] File not found: $WAR"
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
    echo "Fix the WORKSPACE variable in the script."
    exit 1
fi

echo "[2/2] Starting Structurizr Lite on port $PORT..."
echo "      Open http://localhost:$PORT in your browser"
echo "      Press Ctrl+C to stop"
echo

if [ -n "$WORKSPACE" ]; then
    java -Dserver.port="$PORT" -Dstructurizr.workspacePath="$WORKSPACE" -jar "$WAR"
else
    java -Dserver.port="$PORT" -jar "$WAR"
fi
