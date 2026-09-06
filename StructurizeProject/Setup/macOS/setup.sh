#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DISTRIB="$ROOT/Distrib"

echo "=========================================="
echo "  Structurizr Setup Script - macOS"
echo "=========================================="
echo ""

# === Step 1: Distrib folder ===
echo "[1/3] Checking Distrib folder..."
if [ ! -d "$DISTRIB" ]; then
    mkdir -p "$DISTRIB"
    echo "  Created: $DISTRIB"
else
    echo "  Already exists: $DISTRIB"
fi
echo ""

# === Step 2: Structurizr files ===
echo "[2/3] Checking Structurizr Lite and CLI..."

HAS_LITE=0
for f in "$DISTRIB"/structurizr-lite*.war; do
    if [ -f "$f" ]; then
        HAS_LITE=1
        break
    fi
done

HAS_CLI=0
if [ -f "$DISTRIB/structurizr-cli.zip" ]; then
    HAS_CLI=1
fi

if [ "$HAS_LITE" -eq 1 ]; then
    echo "  Structurizr Lite .war found."
else
    echo "  No structurizr-lite*.war found. Downloading latest..."

    LITE_TAG=$(curl -sL https://api.github.com/repos/structurizr/lite/releases/latest \
        | grep '"tag_name":' \
        | sed 's/.*"tag_name": "\(.*\)",/\1/')

    if [ -z "$LITE_TAG" ]; then
        LITE_TAG="v2025.11.08"
    fi

    echo "  Downloading: structurizr-lite.war ($LITE_TAG)"
    curl -sL "https://github.com/structurizr/lite/releases/download/$LITE_TAG/structurizr-lite.war" \
        -o "$DISTRIB/structurizr-lite.war"

    if [ ! -f "$DISTRIB/structurizr-lite.war" ]; then
        echo "  Download failed. Please download manually from:"
        echo "    https://github.com/structurizr/lite/releases"
        exit 1
    fi
    echo "  Download complete."
fi

if [ "$HAS_CLI" -eq 1 ]; then
    echo "  Structurizr CLI zip found."
else
    echo "  No structurizr-cli.zip found. Downloading..."

    CLI_TAG=$(curl -sL https://api.github.com/repos/structurizr/cli/releases/latest \
        | grep '"tag_name":' \
        | sed 's/.*"tag_name": "\(.*\)",/\1/')

    if [ -z "$CLI_TAG" ]; then
        CLI_TAG="v2025.11.09"
    fi

    echo "  Downloading: structurizr-cli.zip ($CLI_TAG)"
    curl -sL "https://github.com/structurizr/cli/releases/download/$CLI_TAG/structurizr-cli.zip" \
        -o "$DISTRIB/structurizr-cli.zip"

    if [ ! -f "$DISTRIB/structurizr-cli.zip" ]; then
        echo "  Download failed. Please download manually from:"
        echo "    https://github.com/structurizr/cli/releases"
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
        echo "  Note: Structurizr works best with Java 21+."
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
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "  Run Start/start-structurizr-lite.sh to get started."
echo ""