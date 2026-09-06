#!/bin/bash

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
DISTRIB_DIR="$(cd "$(dirname "$0")/../../Distrib" && pwd)"

# Directory to watch for changes (leave empty to use . or pass as first argument)
WATCH_DIR="."

# ============================================================

JAR_PATH="$(ls "$DISTRIB_DIR"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR_PATH" ]; then
    echo "plantuml*.jar not found in $DISTRIB_DIR. Run Setup/Mac/setup.sh first."
    exit 1
fi

if [ -n "${1:-}" ]; then
    WATCH_DIR="$1"
fi
echo "Watching $WATCH_DIR for changes..."
java -jar "$JAR_PATH" -watch "$WATCH_DIR" -duration 500