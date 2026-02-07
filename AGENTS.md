# AGENTS.md - Guidelines for AI Coding Agents

Tento dokument obsahuje pravidla a konvence pro AI coding agenty pracující v Google Apps Script Workspace projektu.

**Verze:** 1.0.0  
**Vytvořeno:** 2026-02-08  
**Poslední update:** 2026-02-08  
**Prostředí:** Fedora Silverblue 43 (Toolbx: `code`)

---

## 🎯 Účel projektu

Tento repozitář slouží pro **vývoj a správu Google Apps Script projektů**. Primární obsah:

- 🚀 Apps Script projekty (standalone, add-ony, webapps)
- 📝 Dokumentace workflow a best practices
- 🔧 Utility skripty pro automatizaci
- 📚 Templates a boilerplate kód
- 📜 Changelog entries pro tracking změn

---

## 💬 Komunikační styl

**VŽDY komunikuj podle těchto pravidel:**

- 🗣️ **Jazyk:** Technická čeština (anglické termíny NEPŘEKLÁDAT)
- 📝 **Styl:** Stručný, neformální, parťácký přístup
- 😎 **Tone:** "Beru tě do hry" - společně to zvládneme!
- ✨ **Formátování:** Emoji, ASCII grafika v terminálu, dobré čitelné členění
- 🚀 **Fokus:** Rychlé čtení, konkrétní informace, žádné kecy

### ❓ Používání Question Tool

**VŽDY použij `question` tool místo freeform textových otázek když:**
- ✅ Nabízíš výběr z několika možností
- ✅ Ptáš se na yes/no rozhodnutí
- ✅ Zjišťuješ user preference
- ✅ Nabízíš multiple-choice akce

**ASCII box formátování:**
- **NIKDY nedávej emoji dovnitř box drawing characters**
- Emoji mají variabilní šířku → ničí zarovnání
- Pro checklisty používej: `✓` (hotovo), `✗` (selhalo), `-` (pending)

---

## 🖥️ Prostředí a systémová pravidla

### Architektura systému

- **Host OS:** Fedora Silverblue 43 (immutable)
- **Toolbox:** `code` (unified development environment)
- **Editor:** Neovim (nvim) - modalní editor
- **Shell:** Bash
- **Package Managers:** DNF (toolbox), npm (global installs)

### Instalace software - KRITICKÁ PRAVIDLA

**Pro Apps Script development:**

1. **npm global installs** - pro development tools
   ```bash
   npm install -g @google/clasp
   npm install -g eslint prettier
   ```

2. **DNF v toolboxu** - pro system dependencies
   ```bash
   sudo dnf install -y nodejs npm
   ```

---

## 🔨 Build/Lint/Test Commands

### Linting

**JavaScript (ESLint):**
```bash
# Lint všechny .js soubory v projektu
eslint projects/**/*.js

# Autofix
eslint --fix projects/**/*.js

# Lint konkrétní projekt
cd projects/my-project
eslint *.js
```

**Formatting (Prettier):**
```bash
# Check formatting
prettier --check projects/**/*.js

# Auto-format
prettier --write projects/**/*.js

# Format konkrétní projekt
cd projects/my-project
prettier --write *.js
```

### Clasp workflow

**Development:**
```bash
# Pull changes from Google Apps Script
clasp pull

# Push local changes to Google
clasp push

# Status check (what changed)
clasp status

# Open project in browser
clasp open
```

**Deployment:**
```bash
# Create immutable version
clasp version "v1.0.0"

# List versions
clasp versions

# Deploy
clasp deploy --description "Production release"

# List deployments
clasp deployments
```

### Testing

**Status:** Apps Script projekty se testují primárně v Google Apps Script editoru.

**Manuální testing:**
```bash
# 1. Syntax check
bash -n script.sh

# 2. ESLint check
eslint Code.js

# 3. Push a test v browseru
clasp push
clasp open
```

---

## 📝 Code Style Guidelines

### JavaScript (Apps Script)

**Základní struktura:**
```javascript
/**
 * Function description
 * 
 * @param {string} param - Parameter description
 * @returns {string} Return value description
 */
function myFunction(param) {
  try {
    // Logic here
    Logger.log('Starting execution...');
    
    const result = doSomething(param);
    return result;
  } catch (error) {
    Logger.log(`Error: ${error.message}`);
    throw error;
  }
}
```

**Naming conventions:**
- Funkce: camelCase (`onOpen`, `processData`, `sendEmail`)
- Konstanty: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_KEY`)
- Proměnné: camelCase (`userData`, `sheetData`, `emailList`)
- Soubory: PascalCase.js (`Code.js`, `Utils.js`, `EmailService.js`)

**Best practices:**
- ✅ Vždy použij JSDoc komentáře pro funkce
- ✅ Separuj business logic od UI kódu
- ✅ Používej `Logger.log()` pro debugging
- ✅ Try-catch bloky pro error handling
- ✅ Const/let místo var
- ✅ Single quotes pro stringy
- ✅ Semicolony na konci statements

### Bash skripty

**Základní struktura:**
```bash
#!/bin/bash
# Script name: script-name.sh
# Description: Co skript dělá
# Author: m4p1x
# Date: YYYY-MM-DD

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo "[$(date +'%H:%M:%S')] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

main() {
    log "Starting..."
    # Logic here
    log "Completed"
}

main "$@"
```

### Dokumentace (Markdown)

**Formát:**
```markdown
# Název dokumentu

## Účel
Jednoduchá věta o účelu.

## Obsah

### Sekce 1
...

## Příklady

```bash
command --option value
```

---
**Vytvořeno**: YYYY-MM-DD  
**Poslední aktualizace**: YYYY-MM-DD
```

---

## 📋 Changelog konvence

### Formát changelog záznamu

**Název souboru:**
```
changelog/YYYY-MM-DD-short-description.md
```

**Struktura:** Stejná jako v OpenCode/AGENTS.md s těmito tagy:

### Tags konvence
- `#apps-script` - Apps Script projekty
- `#clasp` - Clasp CLI operace
- `#template` - Nové/upravené templates
- `#scripts` - Utility bash skripty
- `#docs` - Dokumentační změny
- `#config` - ESLint/Prettier konfigurace
- `#initial-setup` - První setup

---

## 🔀 Git workflow konvence

### Branching strategie

**Pro velké změny:**
1. Vytvoř feature branch: `git checkout -b feature/nazev-zmeny`
2. Commituj logické celky
3. Po dokončení: merge do main

**Pro malé změny:**
- Commituj přímo do main

### Commit messages

**Formát:**
```
type: short description

Optional longer description if needed.
```

**Typy:**
- `feat:` - nová funkcionalita (projekt, template, skript)
- `fix:` - oprava chyby
- `docs:` - změny v dokumentaci
- `chore:` - údržba (cleanup, reorganizace)
- `config:` - změny konfigurace (ESLint, Prettier)

---

## 📁 Struktura adresářů

```
gapps-workspace/
├── changelog/          # Chronologické záznamy změn
├── config/             # Sdílené konfigurace (ESLint, Prettier, jsconfig)
├── docs/               # Dokumentace a návody
│   ├── README.md
│   ├── getting-started.md
│   ├── clasp-workflow.md
│   └── examples/
├── projects/           # Aktivní Apps Script projekty
│   ├── my-project-1/
│   └── my-project-2/
├── scripts/            # Utility bash skripty
│   ├── install-deps.sh
│   ├── setup-project.sh
│   └── sync-project.sh
├── templates/          # Project templates
│   ├── standalone/
│   ├── sheets-addon/
│   └── webapp/
├── README.md
├── AGENTS.md
└── LICENSE
```

---

## 📱 Apps Script Development Guidelines

### Project types

**Standalone:** Nezávislé skripty
- Use case: Automatizace, background jobs, scheduled tasks
- Location: `projects/standalone/`
- Triggers: Time-driven, manual execution

**Container-bound:** Vázané na dokument
- Use case: Custom funkcionalita pro konkrétní Sheets/Docs
- Location: `projects/sheets/`, `projects/docs/`
- Triggers: onOpen, onEdit, custom menu items

**Add-ony:** Workspace rozšíření
- Use case: Univerzální tools pro všechny uživatele
- Location: `projects/addons/`
- Publishing: Google Workspace Marketplace

**Webapps:** Standalone web aplikace
- Use case: Custom UI, formuláře, dashboardy
- Location: `projects/webapps/`
- Deployment: Web app URL

### Naming conventions

**Project directories:**
- lowercase-with-dashes: `expense-tracker`, `email-automation`, `data-sync`

**JavaScript files:**
- PascalCase.js: `Code.js`, `Utils.js`, `EmailService.js`, `SheetHelper.js`

**Functions:**
- camelCase: `onOpen()`, `processData()`, `sendEmail()`, `formatSheet()`

### Apps Script API Globals

**Běžně používané:**
- `SpreadsheetApp` - Google Sheets API
- `DocumentApp` - Google Docs API
- `DriveApp` - Google Drive API
- `GmailApp` - Gmail API
- `CalendarApp` - Google Calendar API
- `Logger` - Logging (viditelné v Apps Script editoru)
- `Session` - User session info
- `ScriptApp` - Script metadata a triggers
- `UrlFetchApp` - HTTP requests
- `Utilities` - Utility funkce (base64, sleep, atd.)
- `HtmlService` - HTML UI
- `ContentService` - Text output pro APIs

### Best practices

**Code organization:**
- ✅ Separuj business logic od UI kódu
- ✅ Vytvoř helper funkce v separátních souborech (Utils.js)
- ✅ Používej constants pro magic values
- ✅ Dokumentuj všechny public funkce JSDoc komentáři

**Error handling:**
- ✅ Try-catch bloky pro external API calls
- ✅ Logger.log() pro debugging
- ✅ Meaningful error messages
- ✅ Graceful degradation

**Performance:**
- ✅ Batch operace (např. sheet.getRange().getValues() místo cell-by-cell)
- ✅ Cache data kde je to možné
- ✅ Avoid nested loops s API calls
- ✅ Používej triggers místo polling

**Testing:**
- ✅ Testuj v Google Apps Script editoru před deploymentem
- ✅ Test funkce (např. `function test() { main(); }`)
- ✅ Logger.log() pro debug output
- ✅ Testuj edge cases (prázdná data, chyby API)

**Deployment:**
- ✅ Vždy vytvoř version před deploymentem (`clasp version`)
- ✅ Použij descriptive deployment messages
- ✅ Test v test prostředí před production deploymentem
- ✅ Dokumentuj API scopes v appsscript.json

---

## 🤖 Pravidla pro AI agenty

### Při vytváření nových Apps Script projektů

1. **Použij setup skript** - `./scripts/setup-project.sh project-name type`
2. **Zkontroluj template** - vyber správný template pro use case
3. **Dokumentuj v README** - co projekt dělá, jak ho používat
4. **Setup ESLint/Prettier** - automaticky kopírováno ze `config/`

### Při psaní Apps Script kódu

1. **JSDoc komentáře** pro všechny funkce
2. **Logger.log()** pro debugging
3. **Try-catch** pro external API calls
4. **Const/let** místo var
5. **ESLint compliance** před commitem

### Při změnách konfigurace

1. **Preferuj project-level config** před global config
2. **Dokumentuj změny** v changelog
3. **Test v konkrétním projektu** před aplikací global

### Při tvorbě dokumentace

1. **Praktické příklady** - ukázky skutečného kódu
2. **Code snippets** s syntax highlighting
3. **Aktualizuj datum** při změnách
4. **Linkuj související dokumenty**

---

## 🚨 Kritická upozornění

### ⚠️ NIKDY neprovádět bez souhlasu uživatele:

- ❌ `clasp deploy` do production (vždy se zeptej)
- ❌ Mazání existujících .clasp.json souborů (obsahují Script ID)
- ❌ Globální npm instalace bez potvrzení
- ❌ Změny v appsscript.json bez review (mění scopes)

### ✅ VŽDY provádět:

- ✅ `clasp push` před testováním změn
- ✅ `clasp version` před deploymentem
- ✅ ESLint check před commitem
- ✅ Changelog entry po významných změnách
- ✅ Dokumentování všech API scopes

### ⚡ Apps Script Limity

**Quota limits:**
- Execution time: 6 minut (max)
- Trigger total runtime: 90 minut/den
- UrlFetch calls: 20,000/den
- Email recipients: 100/den (Gmail účet)

**Best practices:**
- Používej batch operace
- Implementuj exponential backoff pro rate limits
- Cache data kde je to možné
- Monitor execution time s `Logger.log()`

---

## 📚 Reference

- [Google Apps Script Documentation](https://developers.google.com/apps-script)
- [Clasp Documentation](https://developers.google.com/apps-script/guides/clasp)
- [Apps Script API Reference](https://developers.google.com/apps-script/reference)
- [ESLint Google Config](https://github.com/google/eslint-config-google)
- [Apps Script Best Practices](https://developers.google.com/apps-script/guides/support/best-practices)

---

**Poslední aktualizace:** 2026-02-08  
**Autor:** m4p1x
