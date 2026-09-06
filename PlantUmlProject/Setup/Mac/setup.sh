#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DISTRIB="$ROOT/Distrib"

echo "========================================"
echo " PlantUML Setup Script - macOS"
echo "========================================"
echo ""

# === Step 1: Distrib folder ===
echo "[1/3] Checking Distrib folder..."
if [ ! -d "$DISTRIB" ]; then
    mkdir -p "$DISTRIB"
    if [ $? -ne 0 ]; then
        echo "  Failed to create Distrib folder."
        exit 1
    fi
    echo "  Created: $DISTRIB"
else
    echo "  Already exists: $DISTRIB"
fi
echo ""

# === Step 2: PlantUML jar ===
echo "[2/3] Checking PlantUML jar..."

HAS_JAR=0
for f in "$DISTRIB"/plantuml*.jar; do
    if [ -f "$f" ]; then
        HAS_JAR=1
        break
    fi
done

if [ "$HAS_JAR" -eq 1 ]; then
    echo "  PlantUML jar found."
else
    echo "  No plantuml*.jar found in Distrib. Downloading latest..."

    TAG=$(curl -sL https://api.github.com/repos/plantuml/plantuml/releases/latest \
        | grep '"tag_name":' \
        | sed 's/.*"tag_name": "\(.*\)",/\1/')

    if [ -z "$TAG" ]; then
        TAG="v1.2026.8"
    fi

    VERSION="${TAG#v}"
    JAR_URL="https://github.com/plantuml/plantuml/releases/download/$TAG/plantuml-$VERSION.jar"
    JAR_OUT="$DISTRIB/plantuml-$VERSION.jar"

    echo "  Downloading: plantuml-$VERSION.jar"
    curl -sL "$JAR_URL" -o "$JAR_OUT"

    if [ ! -f "$JAR_OUT" ]; then
        echo "  Download failed. Please download PlantUML manually from:"
        echo "    https://plantuml.com/download"
        exit 1
    fi
    echo "  Download complete."
fi
echo ""

# === Step 3: Java ===
echo "[3/3] Checking Java..."

if command -v java &>/dev/null; then
    echo "  Java is installed."
    java -version 2>&1 | grep "21." >/dev/null
    if [ $? -ne 0 ]; then
        echo "  Note: PlantUML works best with Java 21+."
        echo "  Your version:"
        java -version 2>&1
    else
        echo "  Java 21 detected."
    fi
else
    echo "  Java not found. Installing via Homebrew..."

    if ! command -v brew &>/dev/null; then
        echo "  Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "  Installing OpenJDK 21..."
    brew install openjdk@21

    echo "  Linking OpenJDK..."
    sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk

    echo "  Java installation complete."
    java -version 2>&1
fi

echo ""
echo "========================================"
echo "  Setup complete!"
echo "========================================"
echo ""
echo "  Run Start/Mac/plantuml-cli.sh or plantuml-gui.sh to get started."
echo ""