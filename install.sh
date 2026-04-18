#!/bin/bash
# Argus Agent Installer - Works on macOS, Linux, and WSL
# Usage: curl -fsSL https://raw.githubusercontent.com/argus-agent/argus-agent/main/install.sh | bash

set -e

ARGUS_VERSION="${ARGUS_VERSION:-main}"
INSTALL_DIR="${ARGUS_INSTALL_DIR:-$HOME/.claude/plugins}"

echo "🔍 Installing Argus Agent..."

# Detect OS
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    PLATFORM="darwin"
elif [[ "$OS" == "Linux" ]]; then
    PLATFORM="linux"
elif [[ "$OS" =~ (Msys|MINGW64|CYGWIN) ]]; then
    PLATFORM="windows"
else
    PLATFORM="unknown"
fi

echo "Detected platform: $PLATFORM"

# Create plugins directory
mkdir -p "$INSTALL_DIR"

# Clone or download the plugin
if command -v git &> /dev/null; then
    if [ -d "$INSTALL_DIR/argus-agent/.git" ]; then
        echo "Updating existing argus-agent..."
        cd "$INSTALL_DIR/argus-agent" && git pull
    else
        echo "Cloning argus-agent..."
        git clone "https://github.com/argus-agent/argus-agent.git" "$INSTALL_DIR/argus-agent"
    fi
else
    echo "Git not found. Please install Git or manually copy the argus-agent folder."
    exit 1
fi

# Enable plugin in settings
SETTINGS_FILE="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"

if [ -f "$SETTINGS_FILE" ]; then
    # Check if already enabled
    if grep -q "argus-agent@file" "$SETTINGS_FILE"; then
        echo "✅ Argus Agent already enabled in settings"
    else
        # Add enabledPlugins to settings
        if grep -q '"enabledPlugins"' "$SETTINGS_FILE"; then
            # Append to existing enabledPlugins
            sed -i.bak 's/"enabledPlugins": {/"enabledPlugins": {\n    "argus-agent@file": true,/' "$SETTINGS_FILE"
        else
            # Add enabledPlugins section
            sed -i.bak 's/^{/{\n  "enabledPlugins": {\n    "argus-agent@file": true\n  },/' "$SETTINGS_FILE"
        fi
        echo "✅ Argus Agent enabled in settings"
    fi
else
    # Create new settings file
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "enabledPlugins": {
    "argus-agent@file": true
  }
}
EOF
    echo "✅ Created settings with Argus Agent enabled"
fi

echo ""
echo "✅ Argus Agent installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code or start a new session"
echo "  2. Optionally configure environment variables:"
echo "     export ARGUS_SONAR_URL='http://your-sonar:9000'"
echo "     export ARGUS_FORTIFY_URL='http://your-fortify:8080'"
echo "     export ARGUS_JFROG_URL='http://your-jfrog:8082'"
echo ""
echo "For manual installation, copy the argus-agent folder to ~/.claude/plugins/"
