#!/bin/bash

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
DISTRIB_DIR="$(cd "$(dirname "$0")/../../Distrib" && pwd)"

# Path to the Examples folder or a specific .puml file
PUML_FILE="$(cd "$(dirname "$0")/../../Examples" && pwd)"

# ============================================================

JAR_PATH="$(ls "$DISTRIB_DIR"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR_PATH" ]; then
    echo "plantuml*.jar not found in $DISTRIB_DIR. Run Setup/Mac/setup.sh first."
    exit 1
fi

echo "Opening PlantUML GUI in \"$PUML_FILE\"..."
echo "Double-click factory-method.puml in the list."
java -jar "$JAR_PATH" -gui "$PUML_FILE" &