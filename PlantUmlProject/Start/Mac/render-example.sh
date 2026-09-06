#!/bin/bash

# ============================================================
#   SETTINGS - change these as needed
# ============================================================

# Path to folder containing plantuml*.jar
DISTRIB_DIR="$(cd "$(dirname "$0")/../../Distrib" && pwd)"

# Folder with diagram files
PUML_DIR="$(cd "$(dirname "$0")/../../Examples" && pwd)"

# Diagram file name to open
PUML_FILENAME="factory-method.puml"

# Full path to the diagram file (built from PUML_DIR + PUML_FILENAME)
PUML_FILE="$PUML_DIR/$PUML_FILENAME"

# ============================================================

JAR_PATH="$(ls "$DISTRIB_DIR"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR_PATH" ]; then
    echo "plantuml*.jar not found in $DISTRIB_DIR. Run Setup/Mac/setup.sh first."
    exit 1
fi

echo "Opening PlantUML GUI in \"$PUML_FILE\"..."
echo "Double-click $PUML_FILENAME in the list."
java -jar "$JAR_PATH" -gui "$PUML_FILE" &