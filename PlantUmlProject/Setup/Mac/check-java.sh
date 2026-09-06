#!/bin/bash
echo "Checking Java..."
if command -v java &>/dev/null; then
    java -version 2>&1
    echo "Java is available."
else
    echo "ERROR: Java not found!"
    echo "Run install-java.sh to install Java automatically."
    exit 1
fi