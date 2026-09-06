#!/bin/bash
echo "Checking Java..."
if command -v java &>/dev/null; then
    echo "Java is already installed:"
    java -version 2>&1
    exit 0
fi

echo "Java not found."
echo ""
echo "================================"
echo " Install Java via Homebrew"
echo "================================"
echo ""

if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing OpenJDK 21 via Homebrew..."
brew install openjdk@21

echo ""
echo "Linking OpenJDK..."
sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk

echo ""
echo "Also available for manual download:"
echo "  https://adoptium.net/temurin/releases/?version=21"
echo ""
echo "Java installation complete."
java -version 2>&1