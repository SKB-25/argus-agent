#!/bin/bash
# Argus Security Scanner - Portable, no hardcoded paths
# Uses relative paths and environment variables for company-specific settings

set -e

# Get plugin directory (works whether called from ~/.claude or project .claude)
PLUGIN_DIR="${ARGUS_PLUGIN_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

# Configuration via environment variables
SONAR_URL="${ARGUS_SONAR_URL:-http://localhost:9000}"
SONAR_TOKEN="${ARGUS_SONAR_TOKEN:-}"
FORTIFY_URL="${ARGUS_FORTIFY_URL:-http://localhost:8080}"
JFROG_URL="${ARGUS_JFROG_URL:-http://localhost:8082}"
JFROG_API_KEY="${ARGUS_JFROG_API_KEY:-}"

# Supported languages (can be overridden via ARGUS_LANG_EXTENSIONS)
LANG_EXTENSIONS="${ARGUS_LANG_EXTENSIONS:-py|js|ts|tsx|jsx|java|c|cpp|cs|go|rs|php|rb|swift|kt|scala|vue|svelte}"

echo "🔍 Argus Security Scan..."

# Function to check for secrets
check_secrets() {
    echo "Checking for hardcoded secrets..."

    # Check for common credential patterns
    if grep -rIE "(password|passwd|pwd|secret|api[_-]?key|apikey|api[_-]key)\s*=\s*[\"'][^\"']{4,}" --include="*.{py,js,ts,tsx,jsx,java,c,cpp,cs,go,rs,php,rb,swift,kt,scala}" . 2>/dev/null; then
        echo "⚠️  WARNING: Potential hardcoded credential found"
        return 1
    fi

    # Check for AWS keys
    if grep -rIE "(AKIA|A3T|ASIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}" --include="*.{py,js,ts,java,sh}" . 2>/dev/null; then
        echo "⚠️  WARNING: Potential AWS access key found"
        return 1
    fi

    # Check for private keys
    if grep -rIE "-----BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY-----" --include="*.{pem,key,sh,yaml,yml,json}" . 2>/dev/null; then
        echo "⚠️  WARNING: Potential private key found"
        return 1
    fi

    echo "✅ No obvious secrets found"
    return 0
}

# Function to check for SQL injection
check_sql_injection() {
    echo "Checking for SQL injection patterns..."

    if grep -rIE "(SELECT|INSERT|UPDATE|DELETE|DROP).*\$\{|execute\s*\(\s*[\"'].*%s" --include="*.{py,js,ts,java,php}" . 2>/dev/null | grep -v "^.*:#" > /dev/null; then
        echo "⚠️  WARNING: Potential SQL injection vector detected"
        return 1
    fi

    echo "✅ No obvious SQL injection patterns found"
    return 0
}

# Function to check for command injection
check_command_injection() {
    echo "Checking for command injection patterns..."

    if grep -rIE "(exec|eval|system|shell_exec|proc_open|popen)\s*\(\s*\$\{|Runtime\.exec|ProcessBuilder" --include="*.{py,js,ts,java,php,rb}" . 2>/dev/null | grep -v "^.*:#" > /dev/null; then
        echo "⚠️  WARNING: Potential command injection vector detected"
        return 1
    fi

    echo "✅ No obvious command injection patterns found"
    return 0
}

# Main scan
main() {
    check_secrets || true
    check_sql_injection || true
    check_command_injection || true

    echo "✅ Argus scan complete"
}

main "$@"
