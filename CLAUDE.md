# Argus Agent - Claude Code Plugin

## Overview
Argus (Greek: Ἄργος) - The all-seeing giant with 100 eyes. This plugin watches every corner of your codebase, scanning for bugs, security vulnerabilities, and code quality issues before they reach production.

## Rules
- **Security First**: Always validate inputs, avoid command injection, use parameterized queries
- **Minimal Changes**: Only write code that addresses the specific task - no premature abstractions
- **Single Responsibility**: Each function/module does one thing well
- **Error Handling**: Handle errors at system boundaries, not deep internally
- **Tests**: Verify features work before reporting completion

## Skills
- `code-review`: Review code for bugs, security issues, and quality
- `refactor`: Improve code structure without changing behavior
- `debug`: Systematic debugging with checkpoint and continuation

## Agents
- `explore`: Fast codebase exploration and pattern finding
- `code-fixer`: Apply fixes from code review findings
- `sonar-agent`: Run SonarQube/SonarCloud analysis and parse results
- `fortify-agent`: Run Fortify Static Code Analyzer (SAST) and parse results
- `jfrog-agent`: Run JFrog Xray/Artifactory dependency and container scan

## Usage
Import this plugin into any Claude Code project by copying the plugin folder to `~/.claude/plugins/` or reference it in your project's `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "argus-agent@file": true
  }
}
```
