#!/bin/bash
# Argus Agent - npm post-install helper
# Symlinks plugin files to ~/.claude/plugins/

set -e

HOME_DIR="${HOME:-/root}"
PLUGIN_SOURCE="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DEST="$HOME_DIR/.claude/plugins/argus-agent"

echo "🔍 Argus Agent - Setting up..."

# Create destination directory
mkdir -p "$HOME_DIR/.claude/plugins"

# If already installed, update
if [ -d "$PLUGIN_DEST" ]; then
    echo "📁 Updating existing installation..."
    rm -rf "$PLUGIN_DEST"
fi

# Symlink instead of copy for npm packages
ln -s "$PLUGIN_SOURCE" "$PLUGIN_DEST"

echo "✅ Symlinked to $PLUGIN_DEST"

# Update settings
SETTINGS_FILE="$HOME_DIR/.claude/settings.json"
mkdir -p "$HOME_DIR/.claude"

if [ -f "$SETTINGS_FILE" ]; then
    if ! grep -q "argus-agent@file" "$SETTINGS_FILE"; then
        # Use node to update JSON properly
        node -e "
const fs = require('fs');
const settings = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));
if (!settings.enabledPlugins) settings.enabledPlugins = {};
settings.enabledPlugins['argus-agent@file'] = true;
fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(settings, null, 2));
"
        echo "✅ Enabled in settings.json"
    fi
else
    echo '{"enabledPlugins": {"argus-agent@file": true}}' > "$SETTINGS_FILE"
    echo "✅ Created settings.json"
fi

echo ""
echo "✅ Argus Agent ready!"
echo "   Restart Claude Code to activate."
