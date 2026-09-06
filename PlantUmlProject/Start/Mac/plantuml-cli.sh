#!/bin/bash

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
DISTRIB_DIR="$(cd "$(dirname "$0")/../../Distrib" && pwd)"

# Full path to .puml file (leave empty if not needed, or pass as argument)
PUML_FILE=""

# ============================================================

JAR_PATH="$(ls "$DISTRIB_DIR"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR_PATH" ]; then
    echo "plantuml*.jar not found in $DISTRIB_DIR. Run Setup/Mac/setup.sh first."
    exit 1
fi

java -jar "$JAR_PATH" "$@"