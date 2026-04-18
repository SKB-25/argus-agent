#!/usr/bin/env node
// Argus Agent - Post-install script
// Runs after npm install to configure the plugin

const fs = require('fs');
const path = require('path');
const os = require('os');

const HOME = os.homedir();
const PLUGIN_DIR = path.join(HOME, '.claude', 'plugins', 'argus-agent');
const SETTINGS_FILE = path.join(HOME, '.claude', 'settings.json');

console.log('🔍 Argus Agent - Post-install configuration...\n');

// Check if running in Claude Code environment
if (!fs.existsSync(path.join(HOME, '.claude'))) {
    console.log('⚠️  Claude Code not detected. Skipping auto-configuration.');
    console.log('   Run Claude Code once, then run: npx argus-install\n');
    process.exit(0);
}

// Ensure plugins directory exists
const pluginsDir = path.join(HOME, '.claude', 'plugins');
if (!fs.existsSync(pluginsDir)) {
    fs.mkdirSync(pluginsDir, { recursive: true });
}

// Copy plugin to ~/.claude/plugins if not already there
const currentDir = __dirname;
if (currentDir !== PLUGIN_DIR) {
    console.log('📁 Copying Argus Agent to ~/.claude/plugins/...');

    // For npm install - copy contents
    const srcDirs = ['agents', 'skills', 'rules', 'commands'];
    srcDirs.forEach(dir => {
        const src = path.join(currentDir, dir);
        const dest = path.join(PLUGIN_DIR, dir);
        if (fs.existsSync(src) && !fs.existsSync(dest)) {
            copyDir(src, dest);
        }
    });

    // Copy config files
    const configFiles = ['CLAUDE.md', 'README.md', 'marketplace.json', 'settings.json', 'install.sh', 'package.json'];
    configFiles.forEach(file => {
        const src = path.join(currentDir, file);
        const dest = path.join(PLUGIN_DIR, file);
        if (fs.existsSync(src) && !fs.existsSync(dest)) {
            fs.copyFileSync(src, dest);
        }
    });
}

// Enable plugin in settings.json
try {
    let settings = {};
    if (fs.existsSync(SETTINGS_FILE)) {
        const content = fs.readFileSync(SETTINGS_FILE, 'utf8');
        settings = JSON.parse(content);
    }

    if (!settings.enabledPlugins) {
        settings.enabledPlugins = {};
    }
    settings.enabledPlugins['argus-agent@file'] = true;

    fs.writeFileSync(SETTINGS_FILE, JSON.stringify(settings, null, 2));
    console.log('✅ Enabled argus-agent in settings.json\n');
} catch (err) {
    console.log('⚠️  Could not update settings.json:', err.message);
}

console.log('✅ Argus Agent installed successfully!\n');
console.log('Next steps:');
console.log('  1. Restart Claude Code or start a new session');
console.log('  2. Configure your company tools (optional):');
console.log('     export ARGUS_SONAR_URL="http://sonarqube:9000"');
console.log('     export ARGUS_FORTIFY_URL="http://fortify:8080"');
console.log('     export ARGUS_JFROG_URL="http://jfrog:8082"\n');

function copyDir(src, dest) {
    fs.mkdirSync(dest, { recursive: true });
    const entries = fs.readdirSync(src, { withFileTypes: true });
    for (const entry of entries) {
        const srcPath = path.join(src, entry.name);
        const destPath = path.join(dest, entry.name);
        if (entry.isDirectory()) {
            copyDir(srcPath, destPath);
        } else {
            fs.copyFileSync(srcPath, destPath);
        }
    }
}
