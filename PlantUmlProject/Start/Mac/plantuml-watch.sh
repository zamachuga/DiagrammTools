#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
DISTRIB="$(cd "$DIR/../../Distrib" && pwd)"
JAR="$(ls "$DISTRIB"/plantuml*.jar 2>/dev/null | head -1)"
if [ -z "$JAR" ]; then
    echo "plantuml*.jar not found in Distrib. Run Setup/Mac/setup.sh first."
    exit 1
fi
WATCH_DIR="${1:-.}"
echo "Watching $WATCH_DIR for changes..."
java -jar "$JAR" -watch "$WATCH_DIR" -duration 500