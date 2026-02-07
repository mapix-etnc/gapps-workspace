#!/bin/bash
# Script name: install-deps.sh
# Description: Instaluje všechny potřebné dependencies pro Apps Script development
# Author: m4p1x
# Date: 2026-02-08

set -euo pipefail

readonly LOG_FILE="/tmp/gapps-workspace-install.log"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo "[$(date +'%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

check_npm() {
    if ! command -v npm &>/dev/null; then
        error "npm není nainstalovaný. Nainstaluj Node.js nejdřív."
    fi
    log "✓ npm nalezen: $(npm --version)"
}

install_clasp() {
    log "📦 Instalace @google/clasp..."
    if npm install -g @google/clasp 2>&1 | tee -a "$LOG_FILE"; then
        log "✓ clasp nainstalován: $(clasp --version 2>/dev/null || echo 'installed')"
    else
        error "Instalace clasp selhala"
    fi
}

install_eslint() {
    log "📦 Instalace ESLint..."
    if npm install -g eslint eslint-config-google 2>&1 | tee -a "$LOG_FILE"; then
        log "✓ ESLint nainstalován: $(eslint --version)"
    else
        error "Instalace ESLint selhala"
    fi
}

install_prettier() {
    log "📦 Instalace Prettier..."
    if npm install -g prettier eslint-config-prettier eslint-plugin-prettier 2>&1 | tee -a "$LOG_FILE"; then
        log "✓ Prettier nainstalován: $(prettier --version)"
    else
        error "Instalace Prettier selhala"
    fi
}

install_types() {
    log "📦 Instalace @types/google-apps-script..."
    if npm install -g @types/google-apps-script 2>&1 | tee -a "$LOG_FILE"; then
        log "✓ Google Apps Script types nainstalovány"
    else
        error "Instalace types selhala"
    fi
}

verify_installation() {
    log "🔍 Verifikace instalace..."
    
    local all_ok=true
    
    if ! command -v clasp &>/dev/null; then
        log "✗ clasp není dostupný"
        all_ok=false
    fi
    
    if ! command -v eslint &>/dev/null; then
        log "✗ eslint není dostupný"
        all_ok=false
    fi
    
    if ! command -v prettier &>/dev/null; then
        log "✗ prettier není dostupný"
        all_ok=false
    fi
    
    if [[ "$all_ok" = false ]]; then
        error "Některé dependencies nejsou dostupné"
    fi
    
    log "✓ Všechny dependencies jsou dostupné"
}

main() {
    log "═══════════════════════════════════════════════════"
    log "  Google Apps Script Development Dependencies"
    log "═══════════════════════════════════════════════════"
    log ""
    
    check_npm
    install_clasp
    install_eslint
    install_prettier
    install_types
    verify_installation
    
    log ""
    log "═══════════════════════════════════════════════════"
    log "  ✓ HOTOVO - Všechny dependencies nainstalované"
    log "═══════════════════════════════════════════════════"
    log ""
    log "📝 Další kroky:"
    log "   1. clasp login     (OAuth autentizace)"
    log "   2. ./scripts/setup-project.sh my-project standalone"
    log ""
    log "📊 Log soubor: $LOG_FILE"
}

main "$@"
