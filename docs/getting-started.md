# Getting Started - Google Apps Script Workspace

Kompletní guide pro setup a práci s gapps-workspace development environment.

---

## 🎯 Co je gapps-workspace?

Universal development environment pro **Google Apps Script** projekty s:
- ✅ Lokální development pomocí `clasp` CLI
- ✅ Code quality tools (ESLint + Prettier)
- ✅ Ready-to-use project templates
- ✅ Automation skripty
- ✅ Best practices a dokumentace

---

## 🚀 Initial Setup

### 1. Prerequisites

**Zkontroluj že máš:**
```bash
# Node.js a npm
node --version  # v16.0.0 nebo vyšší
npm --version   # v7.0.0 nebo vyšší

# Git
git --version

# Google Account s přístupem k Apps Script
```

**Pokud nemáš Node.js:**
```bash
# V toolboxu 'code' (Fedora)
sudo dnf install -y nodejs npm

# Nebo nvm (doporučeno pro version management)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
```

---

### 2. Clone Repository

```bash
# Clone z GitHub (pokud už je pushed)
cd ~/Git
git clone git@github.com:m4p1x/gapps-workspace.git
cd gapps-workspace

# NEBO použij existující lokální repo
cd ~/Git/gapps-workspace
```

---

### 3. Install Dependencies

```bash
# Spusť installation script
./scripts/install-deps.sh

# Verifikace
clasp --version       # @google/clasp 2.x.x
eslint --version      # 8.x.x nebo 9.x.x
prettier --version    # 3.x.x
```

**Co se nainstaluje:**
- `@google/clasp` - Apps Script CLI
- `eslint` + `eslint-config-google` - Linting
- `prettier` + plugins - Formatting
- `@types/google-apps-script` - IntelliSense definitions

---

### 4. Authenticate Clasp

**První autentizace:**
```bash
clasp login
```

**Co se stane:**
1. Otevře se browser s Google OAuth prompt
2. Přihlaš se svým Google účtem
3. Povol clasp přístup k Apps Script
4. Token se uloží do `~/.clasprc.json`

**Ověření:**
```bash
clasp whoami
# Should show: email@gmail.com
```

**Troubleshooting:**
```bash
# Pokud login nefunguje nebo chceš změnit účet
clasp logout
clasp login
```

---

## 🛠️ Vytvoření prvního projektu

### Quick Start - Použití template

```bash
# Syntaxe
./scripts/setup-project.sh <project-name> <template-type>

# Příklad - standalone automation script
./scripts/setup-project.sh hello-world standalone
```

**Dostupné template types:**
- `standalone` - Basic automation script (email automation, data processing)
- `sheets-addon` - Sheets add-on s menu + sidebar
- `webapp` - Web aplikace s HTML UI

---

### Krok za krokem - Hello World

**1. Vytvoř projekt:**
```bash
cd ~/Git/gapps-workspace
./scripts/setup-project.sh hello-world standalone
```

**2. Přejdi do projektu:**
```bash
cd projects/hello-world
ls -la
# Code.js, appsscript.json, README.md, .eslintrc.json, .prettierrc
```

**3. Vytvoř Apps Script project v Google:**
```bash
clasp create --type standalone --title "Hello World"
```

**Output:**
```
Created new standalone script: https://script.google.com/d/SCRIPT_ID/edit
```

**Co se stalo:**
- Vytvořil se nový Apps Script project v Google cloudu
- Vygeneroval se `.clasp.json` s Script ID (lokálně, .gitignored)
- Project je připravený na sync

**4. Push kódu do Apps Script:**
```bash
clasp push
```

**Output:**
```
└─ Code.js
└─ appsscript.json
Pushed 2 files.
```

**5. Otevři v Apps Script editoru:**
```bash
clasp open
```
→ Otevře browser s Apps Script editorem

**6. Spusť funkci:**
V Apps Script editoru:
- Vyber funkci `myFunction` z dropdown
- Klikni ▶️ Run
- Zkontroluj Execution log

---

## 📝 Development Workflow

### Základní cycle

```bash
# 1. Edit lokálně (nvim, VS Code, atd.)
nvim Code.js

# 2. Lint a format
npm run lint      # ESLint check
npm run format    # Prettier format

# 3. Push změny
clasp push

# 4. Test v Apps Script editoru
clasp open
# → Run funkci, zkontroluj logs

# 5. Pull updates (pokud editoval v browseru)
clasp pull
```

---

### Práce s více funkcemi

**Code.js example:**
```javascript
/**
 * Main function - automation entry point
 */
function main() {
  Logger.log('Starting automation...');
  const data = fetchData();
  processData(data);
  Logger.log('Completed successfully');
}

/**
 * Fetch data from external source
 */
function fetchData() {
  const response = UrlFetchApp.fetch('https://api.example.com/data');
  return JSON.parse(response.getContentText());
}

/**
 * Process and store data
 */
function processData(data) {
  // Processing logic
  Logger.log(`Processed ${data.length} items`);
}
```

**Spouštění:**
- V Apps Script editoru vyber `main` a klikni Run
- Nebo nastav time-based trigger pro automatické spouštění

---

### Time-based triggers

**Setup přes UI:**
1. `clasp open` → otevři editor
2. Klikni ⏰ (Triggers) v levém sidebaru
3. Add Trigger:
   - Function: `main`
   - Event source: Time-driven
   - Type: Day timer → 9am to 10am

**Setup programmaticky:**
```javascript
function createTrigger() {
  ScriptApp.newTrigger('main')
    .timeBased()
    .everyDays(1)
    .atHour(9)
    .create();
}
```

---

## 🧰 Užitečné příkazy

### Clasp commands

```bash
# Status projektu
clasp status

# Pull z cloudu
clasp pull

# Push do cloudu
clasp push

# Watch mode (auto-push při změnách)
clasp push --watch

# Otevři v editoru
clasp open

# Otevři deployments
clasp deploy

# Logs (execution logs)
clasp logs

# List všech projektů
clasp list
```

### Project management

```bash
# Vytvoř nový projekt
./scripts/setup-project.sh my-project standalone

# List všech projektů
ls -1 projects/

# Přepni mezi projekty
cd projects/project-name
clasp open
```

---

## 🔧 Editor Setup

### Neovim

**LSP support:**
```lua
-- ~/.config/nvim/lua/lsp-config.lua
require('lspconfig').eslint.setup{}
```

**Auto-format on save:**
```lua
-- ~/.config/nvim/lua/format-on-save.lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.js",
  callback = function()
    vim.cmd("silent! !prettier --write %")
  end,
})
```

### VS Code

**Extensions:**
- ESLint (`dbaeumer.vscode-eslint`)
- Prettier (`esbenp.prettier-vscode`)
- Google Apps Script (`rubymaniac.vscode-google-apps-script`)

**Settings:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "eslint.validate": ["javascript"]
}
```

---

## 📊 Project Templates

### 1. Standalone Script

**Použití:**
- Email automation
- Data processing
- Scheduled tasks
- API integrations

**Příklad:**
```bash
./scripts/setup-project.sh email-digest standalone
cd projects/email-digest
clasp create --type standalone
clasp push
```

---

### 2. Sheets Add-on

**Použití:**
- Custom menu v Google Sheets
- Sidebar UI
- Data manipulation
- Import/export tools

**Features:**
- Custom menu: "My Add-on" → "Open Sidebar"
- HTML sidebar s modern UI
- Two-way communication (client ↔ server)

**Příklad:**
```bash
./scripts/setup-project.sh expense-tracker sheets-addon
cd projects/expense-tracker
clasp create --type sheets
clasp push
```

**Test:**
1. `clasp open` → otevře Sheets s add-onem
2. Reload sheet
3. Menu "My Add-on" → "Open Sidebar"

---

### 3. Web App

**Použití:**
- Public dashboards
- Forms a data collection
- API endpoints
- Interactive tools

**Features:**
- Modern HTML/CSS UI
- doGet() handler pro GET requests
- doPost() handler pro POST requests
- google.script.run pro server calls

**Příklad:**
```bash
./scripts/setup-project.sh dashboard webapp
cd projects/dashboard
clasp create --type webapp
clasp push
clasp deploy
```

**Deployment:**
```bash
# Deploy as web app
clasp deploy --description "v1.0.0"

# Get deployment URL
clasp deployments
# → https://script.google.com/macros/s/DEPLOYMENT_ID/exec
```

**Access control:**
- "Only myself" - private
- "Anyone within organization" - internal
- "Anyone" - public

---

## 🐛 Troubleshooting

### Clasp authentication issues

**Problem:** `clasp login` fails nebo token expired

**Solution:**
```bash
clasp logout
clasp login
# Zkus znovu s novým tokenem
```

---

### Push conflicts

**Problem:** `Push failed: Conflict`

**Solution:**
```bash
# Pull nejnovější verzi
clasp pull

# Resolve conflicts lokálně
nvim Code.js

# Push znovu
clasp push
```

---

### Missing Script ID

**Problem:** `Could not find .clasp.json`

**Solution:**
```bash
# Vytvoř nový project
clasp create --type standalone

# NEBO přidej existující Script ID
echo '{"scriptId":"YOUR_SCRIPT_ID"}' > .clasp.json
```

---

### ESLint errors

**Problem:** Spousta ESLint errors po push

**Solution:**
```bash
# Fix auto-fixable issues
npm run lint -- --fix

# NEBO disable specific rule v souboru
/* eslint-disable no-unused-vars */
```

---

## 📚 Next Steps

1. **Prostuduj [Clasp Workflow](clasp-workflow.md)** - advanced commands, deployment
2. **Nastav editor** podle [ESLint & Prettier Setup](eslint-prettier.md)
3. **Prozkoumej templates** v `../templates/` - reference pro různé typy projektů
4. **Přečti [Apps Script Best Practices](https://developers.google.com/apps-script/guides/support/best-practices)**

---

## 🔗 Resources

- [Google Apps Script Documentation](https://developers.google.com/apps-script)
- [Clasp GitHub](https://github.com/google/clasp)
- [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html)

---

**Vytvořeno:** 2026-02-08  
**Autor:** m4p1x
