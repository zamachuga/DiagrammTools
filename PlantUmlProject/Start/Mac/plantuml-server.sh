#!/bin/bash

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
DISTRIB_DIR="$(cd "$(dirname "$0")/../../Distrib" && pwd)"

# Port for the web server
SERVER_PORT="${1:-8080}"

# ============================================================

JAR_PATH="$(ls "$DISTRIB_DIR"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR_PATH" ]; then
    echo "plantuml*.jar not found in $DISTRIB_DIR. Run Setup/Mac/setup.sh first."
    exit 1
fi

echo "Starting PlantUML web server on http://localhost:$SERVER_PORT"
echo "Press Ctrl+C to stop."
java -jar "$JAR_PATH" -picoweb:$SERVER_PORT