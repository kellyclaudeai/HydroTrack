#!/bin/bash
# Create a simple solid color PNG for the app icon placeholder
# Using macOS built-in tools

# Create a 1024x1024 PNG with blue color
cat > AppIcon-1024.png.b64 << 'B64'
iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==
B64

base64 -D < AppIcon-1024.png.b64 > temp.png
sips -z 1024 1024 temp.png --out AppIcon-1024.png 2>/dev/null
rm temp.png AppIcon-1024.png.b64
