#!/bin/bash
# Script name: update-workspace.sh
# Description: Update all dependencies and tools in gapps-workspace
# Author: m4p1x
# Date: 2026-02-08

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"
readonly LOG_FILE="/tmp/gapps-workspace-update.log"

log() { echo "[$(date +'%H:%M:%S')] $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }

print_header() {
    echo "═══════════════════════════════════════════════════" >&2
    echo "  $1" >&2
    echo "═══════════════════════════════════════════════════" >&2
    echo "" >&2
}

check_outdated() {
    local package=$1
    local current_version=$2
    
    log "📦 Checking $package..."
    local latest_version=$(npm view "$package" version 2>/dev/null || echo "unknown")
    
    if [[ "$latest_version" == "unknown" ]]; then
        echo "   ⚠️  $package: nelze zjistit latest verzi" >&2
        return 1
    fi
    
    if [[ "$current_version" != "$latest_version" ]]; then
        echo "   📤 $package: $current_version → $latest_version (update available)" >&2
        return 0
    else
        echo "   ✓ $package: $current_version (up to date)" >&2
        return 1
    fi
}

update_global_tools() {
    print_header "Aktualizace globálních nástrojů"
    
    # Clasp
    if command -v clasp &> /dev/null; then
        local clasp_version=$(clasp --version 2>&1 | head -1 || echo "unknown")
        if check_outdated "@google/clasp" "$clasp_version"; then
            log "Updating clasp..."
            npm install -g @google/clasp || error "Clasp update selhal"
            log "✓ Clasp aktualizován"
        fi
    else
        log "⚠️  Clasp není nainstalovaný"
    fi
    
    echo "" >&2
}

update_local_dependencies() {
    print_header "Aktualizace lokálních dependencies"
    
    cd "$ROOT_DIR" || error "Nepodařilo se přejít do $ROOT_DIR"
    
    if [[ ! -f "package.json" ]]; then
        log "⚠️  package.json nenalezen, přeskakuji local dependencies"
        return
    fi
    
    log "📊 Checking outdated packages..."
    echo "" >&2
    
    # Show outdated packages
    npm outdated || true
    
    echo "" >&2
    log "💡 Chceš aktualizovat? Spusť:"
    log "   npm update              (minor/patch updates)"
    log "   npm update --latest     (major updates - breaking changes!)"
    
    echo "" >&2
}

check_npm_audit() {
    print_header "Security audit"
    
    cd "$ROOT_DIR" || error "Nepodařilo se přejít do $ROOT_DIR"
    
    log "🔒 Running npm audit..."
    echo "" >&2
    
    if npm audit --audit-level=moderate; then
        log "✓ Žádné security vulnerabilities"
    else
        log "⚠️  Nalezeny security issues! Fix pomocí:"
        log "   npm audit fix           (automatické opravy)"
        log "   npm audit fix --force   (i breaking changes)"
    fi
    
    echo "" >&2
}

check_git_status() {
    print_header "Git status"
    
    cd "$ROOT_DIR" || error "Nepodařilo se přejít do $ROOT_DIR"
    
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        log "⚠️  Máš uncommitted changes:"
        git status --short
    else
        log "✓ Working tree clean"
    fi
    
    echo "" >&2
    
    # Check remote updates
    log "📡 Checking remote updates..."
    git fetch origin main --quiet || log "⚠️  Nepodařilo se fetchnout z remote"
    
    local behind=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "0")
    local ahead=$(git rev-list origin/main..HEAD --count 2>/dev/null || echo "0")
    
    if [[ $behind -gt 0 ]]; then
        log "📥 Remote je $behind commits ahead - pull pomocí: git pull"
    fi
    
    if [[ $ahead -gt 0 ]]; then
        log "📤 Local je $ahead commits ahead - push pomocí: git push"
    fi
    
    if [[ $behind -eq 0 && $ahead -eq 0 ]]; then
        log "✓ Git je synchronized s remote"
    fi
    
    echo "" >&2
}

show_summary() {
    print_header "📊 Summary"
    
    log "Workspace location: $ROOT_DIR"
    log "Log file: $LOG_FILE"
    
    echo "" >&2
    log "📚 Quick commands:"
    log "   npm outdated            # Show outdated packages"
    log "   npm update              # Update to latest compatible versions"
    log "   npm audit               # Security audit"
    log "   clasp --version         # Check clasp version"
    log "   git pull                # Pull from GitHub"
    
    echo "" >&2
}

main() {
    print_header "Google Apps Script Workspace Update"
    
    # Run checks
    update_global_tools
    update_local_dependencies
    check_npm_audit
    check_git_status
    show_summary
    
    log "✓ Update check dokončen"
    
    echo "═══════════════════════════════════════════════════" >&2
    echo "  ✓ HOTOVO" >&2
    echo "═══════════════════════════════════════════════════" >&2
}

# Execute
main "$@" 2>&1 | tee "$LOG_FILE"
