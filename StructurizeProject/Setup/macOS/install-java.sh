#!/bin/bash
# Install Java 21 (Temurin) for Structurizr on macOS (Apple Silicon)
set -e

echo "=========================================="
echo "  Install Java 21 (Temurin) for Structurizr"
echo "  macOS (arm64)"
echo "=========================================="
echo

# Check if Homebrew is available
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew found. Installing OpenJDK 21..."
    brew install --cask temurin@21
    echo "Java 21 installed successfully."
else
    echo "Homebrew not found."
    echo "Opening the download page instead..."
    open "https://adoptium.net/temurin/releases/?version=21&os=mac&arch=aarch64"
fi
