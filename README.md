# Argus Agent - Claude Code Plugin

**Argus** (Greek: Ἄργος) - The all-seeing giant with 100 eyes. Watches every corner of your codebase.

## Features

- **Automatic Security Scanning** - Scans on every Write/Edit operation
- **Pre-commit Security** - Validates commits for hardcoded secrets
- **Multi-Tool Security Agents** - SonarQube, Fortify, JFrog Xray integration
- **Language Agnostic** - Works with Python, Java, JavaScript, TypeScript, Go, Rust, PHP, C/C++, Ruby, Swift, Kotlin, Scala, and more
- **Zero Configuration** - Works out of the box

## Installation

### Option 1: Copy Plugin Folder (Recommended)
```bash
# Clone or copy the argus-agent folder to your plugins directory
cp -r argus-agent ~/.claude/plugins/

# Enable in settings.json
echo '{"enabledPlugins": {"argus-agent@file": true}}' >> ~/.claude/settings.json
```

### Option 2: Add to Project
```bash
# Copy to your project's .claude/plugins folder
cp -r argus-agent /path/to/your/project/.claude/plugins/

# Add to project's .claude/settings.json
echo '{"enabledPlugins": {"argus-agent@file": true}}' > /path/to/your/project/.claude/settings.json
```

## Configuration

### Environment Variables (Optional)
```bash
export ARGUS_SONAR_URL="http://sonarqube:9000"
export ARGUS_SONAR_TOKEN="your-sonar-token"
export ARGUS_FORTIFY_URL="http://fortify:8080"
export ARGUS_JFROG_URL="http://jfrog:8082"
export ARGUS_JFROG_API_KEY="your-jfrog-api-key"
```

### Company Tools Configuration
Edit `agents/sonar-agent.json`, `agents/fortify-agent.json`, and `agents/jfrog-agent.json` to point to your company's SonarQube, Fortify, and JFrog servers.

## Usage

Once installed, Argus runs automatically on every Claude Code session.

### Automatic Behavior
| Action | What Argus Does |
|--------|-----------------|
| Write/Edit Code | Security review for vulnerabilities |
| Git Commit | Pre-commit secrets scan |

### Manual Commands
```
/argus sonar      # Run SonarQube analysis
/argus fortify    # Run Fortify SCA scan
/argus jfrog      # Run JFrog Xray dependency scan
/argus scan       # Quick security scan
/argus review     # Full code review
/argus explore    # Explore codebase patterns
```

## For Plugin Developers

### Structure
```
argus-agent/
├── CLAUDE.md              # This file
├── marketplace.json       # Plugin manifest
├── settings.json         # Plugin settings
├── agents/               # Custom agents
│   ├── explore.json
│   ├── fixer.json
│   ├── sonar-agent.json
│   ├── fortify-agent.json
│   └── jfrog-agent.json
├── skills/               # Custom skills
│   ├── security-review.json
│   └── fast-review.json
├── rules/                # Security & quality rules
│   ├── security.json
│   └── quality.json
└── commands/             # Shell commands
    └── security-scan.sh
```

## License
MIT - Free for personal and commercial use.
