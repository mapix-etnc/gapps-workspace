# Scripts - Utility Tools

Tento adresář obsahuje utility bash skripty pro automatizaci častých operací v gapps-workspace.

---

## 📋 Dostupné skripty

### 1. `install-deps.sh`

**Účel:** Instaluje všechny potřebné Node.js dependencies pro Apps Script development.

**Co instaluje:**
- `@google/clasp` - CLI pro práci s Google Apps Script
- `eslint` + `eslint-config-google` - Linting s Google style guide
- `prettier` + `prettier-plugin-organize-imports` - Code formatting
- `@types/google-apps-script` - TypeScript type definitions (pro IntelliSense)

**Použití:**
```bash
cd ~/Git/gapps-workspace
./scripts/install-deps.sh
```

**Output:**
- Instaluje global npm packages (`-g`)
- Vytváří `package.json` v root projektu
- Loguje všechny operace do `~/Git/gapps-workspace/install-deps.log`
- Verifikuje instalaci pomocí `--version` checks

**Requirements:**
- Node.js a npm musí být nainstalované
- Internet connection
- Práva pro global npm install (může vyžadovat `sudo` podle npm konfigurace)

---

### 2. `setup-project.sh`

**Účel:** Rychlé vytvoření nového Apps Script projektu z template.

**Použití:**
```bash
./scripts/setup-project.sh <project-name> <template-type>
```

**Parametry:**
- `project-name` - Název projektu (lowercase, pomlčky povoleny)
- `template-type` - Typ template: `standalone`, `sheets-addon`, nebo `webapp`

**Příklady:**
```bash
# Vytvoř standalone automation script
./scripts/setup-project.sh email-automation standalone

# Vytvoř Sheets add-on
./scripts/setup-project.sh expense-tracker sheets-addon

# Vytvoř web aplikaci
./scripts/setup-project.sh dashboard-app webapp
```

**Co dělá:**
1. Validuje parametry (project name a template type)
2. Zkontroluje že projekt ještě neexistuje
3. Vytvoří directory v `projects/`
4. Zkopíruje template soubory
5. Nahradí placeholdery v souborech (název projektu, datum)
6. Vytvoří `projects/project-name/README.md` s next steps

**Output:**
```
✓ HOTOVO - Projekt vytvořen
───────────────────────────────
Lokace: projects/email-automation

DALŠÍ KROKY:
1. cd projects/email-automation
2. clasp create --type standalone
3. clasp push
4. clasp open

Pro více info: cat README.md
```

**Chybové stavy:**
- Missing parametry → zobrazí usage
- Neplatný template type → zobrazí dostupné typy
- Projekt už existuje → error + exit

---

### 3. `update-workspace.sh`

**Účel:** Pravidelná kontrola a update všech dependencies a tools.

**Použití:**
```bash
cd ~/Git/gapps-workspace
./scripts/update-workspace.sh
```

**Co dělá:**
1. Zkontroluje globální tools (clasp) a najde updates
2. Zkontroluje outdated npm packages
3. Spustí npm security audit
4. Zkontroluje git status (uncommitted changes, remote sync)
5. Zobrazí summary s doporučenými akcemi

**Output:**
```
═══════════════════════════════════════════
  Aktualizace globálních nástrojů
───────────────────────────────────────────
 ✓ clasp: 3.2.0 (up to date)

═══════════════════════════════════════════
  Aktualizace lokálních dependencies
───────────────────────────────────────────
 📊 Checking outdated packages...
 
Package    Current  Wanted  Latest
eslint     8.57.0   8.57.1  10.0.0

💡 Chceš aktualizovat? Spusť:
   npm update              (minor/patch)
   npm update --latest     (major updates)
```

**Doporučená frekvence:** 1× měsíčně nebo před začátkem nového projektu

**Log file:** `/tmp/gapps-workspace-update.log`

---

## 🔧 Development

### Přidání nového skriptu

1. Vytvoř `scripts/new-script.sh`
2. Použij standard bash structure:
   ```bash
   #!/bin/bash
   set -euo pipefail
   
   readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   readonly LOG_FILE="/tmp/new-script.log"
   
   log() {
       echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
   }
   
   main() {
       log "Starting..."
       # Logic here
   }
   
   main "$@"
   ```
3. Nastav executable: `chmod +x scripts/new-script.sh`
4. Test syntax: `bash -n scripts/new-script.sh`
5. Dokumentuj v tomto README.md

### Testing

```bash
# Syntax check
bash -n scripts/script-name.sh

# ShellCheck (pokud nainstalovaný)
shellcheck scripts/script-name.sh

# Test v safe prostředí
toolbox create test-env
toolbox enter test-env
cd ~/Git/gapps-workspace
./scripts/script-name.sh
```

---

## 📝 Poznámky

**Logging:**
- Všechny skripty logují do `/tmp/script-name.log`
- V případě chyby zkontroluj log pro detaily

**Error handling:**
- `set -euo pipefail` zajišťuje exit při jakékoliv chybě
- Error messages jsou na stderr (`>&2`)

**Permissions:**
- Po vytvoření nebo update skriptu: `chmod +x scripts/script-name.sh`
- Git track executable permission automaticky

---

**Vytvořeno:** 2026-02-08  
**Autor:** m4p1x
