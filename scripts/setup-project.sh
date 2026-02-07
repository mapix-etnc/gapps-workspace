#!/bin/bash
# Script name: setup-project.sh
# Description: Quick setup script for new Apps Script project
# Author: m4p1x
# Date: 2026-02-08

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"

log() { echo "[$(date +'%H:%M:%S')] $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }

show_usage() {
    cat << EOF
Usage: $0 <project-name> [type]

Arguments:
  project-name    Name of the project (lowercase-with-dashes)
  type            Project type (default: standalone)

Project Types:
  standalone      Nezávislé skripty pro automatizaci
  sheets          Sheets add-on s custom menu a sidebar
  docs            Docs add-on
  webapp          Web aplikace s HTML UI
  
Examples:
  $0 email-automation standalone
  $0 expense-tracker sheets
  $0 custom-dashboard webapp

EOF
    exit 1
}

validate_project_name() {
    local name="$1"
    
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        error "Project name musí být lowercase-with-dashes (např: my-project)"
    fi
    
    if [[ -d "$ROOT_DIR/projects/$name" ]]; then
        error "Projekt '$name' již existuje v projects/"
    fi
}

create_project_directory() {
    local project_name="$1"
    local project_dir="$ROOT_DIR/projects/$project_name"
    
    log "📁 Vytváření projektu: $project_name"
    mkdir -p "$project_dir" || error "Nepodařilo se vytvořit adresář"
    
    echo "$project_dir"
}

initialize_clasp() {
    local project_dir="$1"
    local project_name="$2"
    local project_type="$3"
    
    cd "$project_dir" || error "Nepodařilo se přejít do $project_dir"
    
    log "🔧 Inicializace clasp projektu (type: $project_type)..."
    
    if ! clasp create --type "$project_type" --title "$project_name" 2>&1; then
        error "clasp create selhalo. Máš spuštěný 'clasp login'?"
    fi
    
    log "✓ Clasp projekt vytvořen"
}

copy_config_files() {
    local project_dir="$1"
    
    log "⚙️  Kopírování config souborů..."
    
    cp "$ROOT_DIR/config/.eslintrc.json" "$project_dir/"
    cp "$ROOT_DIR/config/.prettierrc" "$project_dir/"
    cp "$ROOT_DIR/config/jsconfig.json" "$project_dir/"
    cp "$ROOT_DIR/config/.claspignore" "$project_dir/"
    
    log "✓ Config soubory zkopírovány"
}

copy_template_files() {
    local project_dir="$1"
    local project_type="$2"
    
    log "📄 Kopírování template souborů..."
    
    local template_dir
    case "$project_type" in
        standalone)
            template_dir="$ROOT_DIR/templates/standalone"
            ;;
        sheets|docs|slides|forms)
            template_dir="$ROOT_DIR/templates/sheets-addon"
            ;;
        webapp)
            template_dir="$ROOT_DIR/templates/webapp"
            ;;
        *)
            log "⚠️  Neznámý typ, používám standalone template"
            template_dir="$ROOT_DIR/templates/standalone"
            ;;
    esac
    
    if [[ -d "$template_dir" ]]; then
        cp "$template_dir"/*.{js,html,json,md} "$project_dir/" 2>/dev/null || true
        log "✓ Template soubory zkopírovány z $(basename "$template_dir")"
    else
        log "⚠️  Template adresář nenalezen: $template_dir"
    fi
}

create_project_readme() {
    local project_dir="$1"
    local project_name="$2"
    local project_type="$3"
    
    cat > "$project_dir/README.md" << EOF
# $project_name

Apps Script project - Type: **$project_type**

## Setup

\`\`\`bash
# Pull latest from Google Apps Script
clasp pull

# Push local changes
clasp push

# Open in browser
clasp open
\`\`\`

## Development

1. Edit \`Code.js\` (a další soubory)
2. Lint code: \`eslint *.js\`
3. Format code: \`prettier --write *.js\`
4. Push changes: \`clasp push\`
5. Test v browseru: \`clasp open\`

## Deployment

\`\`\`bash
# Create version
clasp version "v1.0.0"

# Deploy
clasp deploy --description "Production v1.0.0"

# List deployments
clasp deployments
\`\`\`

## Notes

- Script ID je v \`.clasp.json\` (NECHAT v .gitignore)
- OAuth scopes jsou v \`appsscript.json\`
- Logs viditelné přes \`clasp logs\` nebo Apps Script editor

---

**Vytvořeno:** $(date +%Y-%m-%d)  
**Autor:** m4p1x
EOF
    
    log "✓ README.md vytvořen"
}

show_next_steps() {
    local project_dir="$1"
    local project_name="$2"
    
    log ""
    log "═══════════════════════════════════════════════════"
    log "  ✓ Projekt '$project_name' vytvořen!"
    log "═══════════════════════════════════════════════════"
    log ""
    log "📂 Location: $project_dir"
    log ""
    log "📝 Další kroky:"
    log "   1. cd $project_dir"
    log "   2. nvim Code.js              (edit logic)"
    log "   3. clasp push                (nahraj do Google)"
    log "   4. clasp open                (otevři v browseru)"
    log "   5. clasp deploy              (deploy po testování)"
    log ""
}

main() {
    # Parse arguments
    local project_name="${1:-}"
    local project_type="${2:-standalone}"
    
    if [[ -z "$project_name" ]]; then
        show_usage
    fi
    
    # Validate
    validate_project_name "$project_name"
    
    # Create project
    local project_dir
    project_dir=$(create_project_directory "$project_name")
    
    # Initialize clasp
    initialize_clasp "$project_dir" "$project_name" "$project_type"
    
    # Copy files
    copy_config_files "$project_dir"
    copy_template_files "$project_dir" "$project_type"
    create_project_readme "$project_dir" "$project_name" "$project_type"
    
    # Success
    show_next_steps "$project_dir" "$project_name"
}

main "$@"
