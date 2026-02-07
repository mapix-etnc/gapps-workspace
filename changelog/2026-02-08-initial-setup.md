# Changelog - 2026-02-08: Initial Setup - Google Apps Script Workspace

## Datum: 2026-02-08

## Typ změny: Initial Setup

## Popis

Vytvoření kompletního development workspace pro Google Apps Script projekty s lokálním vývojem, verzováním a code quality tools.

Tento setup umožňuje:
- ✅ Lokální vývoj Apps Script projektů pomocí `clasp` CLI
- ✅ Git versioning a GitHub integration
- ✅ Code quality enforcement (ESLint + Prettier)
- ✅ Ready-to-use project templates (standalone, sheets-addon, webapp)
- ✅ Automation skripty pro rychlé setup
- ✅ Kompletní dokumentace a best practices

---

## 🎯 Provedené změny

### 1. Project Structure - Základní struktura

#### Vytvořené adresáře
```
~/Git/gapps-workspace/
├── changelog/          # Chronologické záznamy změn
├── config/            # Shared config files (ESLint, Prettier, atd.)
├── docs/              # Dokumentace a návody
├── projects/          # Individual Apps Script projects
├── scripts/           # Utility bash skripty
└── templates/         # Project templates
    ├── standalone/
    ├── sheets-addon/
    └── webapp/
```

#### Core files
- `README.md` - Project overview + quick start guide
- `LICENSE` - MIT License
- `.gitignore` - Ignore patterns (node_modules, .clasp.json, credentials)
- `AGENTS.md` - AI agent guidelines (adapted from OpenCode/AGENTS.md)

---

### 2. Configuration Files

#### ESLint - `config/.eslintrc.json`
- **Style Guide**: Google JavaScript Style Guide
- **Environment**: ES2021 + Google Apps Script globals
- **Custom Rules**:
  - `no-unused-vars: "warn"` (warning místo error)
  - `max-len: 100` (100 znaků na řádek)
  - `require-jsdoc: "off"` (JSDoc není mandatory)
- **Globals**: SpreadsheetApp, GmailApp, DriveApp, Logger, atd.

#### Prettier - `config/.prettierrc`
- **Style**:
  - Single quotes (`'`)
  - Semicolons (`;`)
  - 2 spaces indent
  - 100 chars line length (match ESLint)
  - Trailing commas (ES5)
  - Arrow function parens always `(x) => x`

#### JavaScript IntelliSense - `config/jsconfig.json`
- Target: ES2021
- Module system: ESNext
- Include: all JS files
- Type checking: enabled

#### Clasp - `config/.claspignore`
- Ignore patterns:
  - `node_modules/`
  - `.git/`
  - `*.md`
  - `.env`
  - Config files

---

### 3. Project Templates

#### Template: Standalone Script (`templates/standalone/`)

**Účel:** Basic automation scripts (email automation, data processing, scheduled tasks)

**Soubory:**
- `Code.js` - Main script with example function
- `appsscript.json` - Manifest (timezone, runtime V8)
- `README.md` - Usage instructions

**Features:**
- Simple function structure
- Logger.log() for debugging
- Ready for time-based triggers

---

#### Template: Sheets Add-on (`templates/sheets-addon/`)

**Účel:** Google Sheets add-ons s custom menu a sidebar UI

**Soubory:**
- `Code.js` - onOpen() menu + sidebar handlers
- `Sidebar.html` - HTML sidebar s modern UI
- `appsscript.json` - Manifest
- `README.md` - Setup a usage guide

**Features:**
- Custom menu: "My Add-on" → "Open Sidebar"
- Two-way communication (client ↔ server via `google.script.run`)
- Modern HTML/CSS UI template
- Example data fetch + display

---

#### Template: Web App (`templates/webapp/`)

**Účel:** Standalone web applications (dashboards, forms, public tools)

**Soubory:**
- `Code.js` - doGet() handler + backend logic
- `Index.html` - Modern HTML/CSS frontend
- `appsscript.json` - Manifest + webapp config
- `README.md` - Deployment guide

**Features:**
- doGet() for serving HTML
- doPost() ready for form handling
- `google.script.run` for async server calls
- Responsive CSS layout
- Access control options (public, private, org-only)

---

### 4. Utility Scripts

#### Script: `scripts/install-deps.sh`

**Účel:** Instalace všech Node.js dependencies

**Co instaluje (global npm):**
- `@google/clasp` - Apps Script CLI
- `eslint` + `eslint-config-google` - Linting
- `prettier` + `prettier-plugin-organize-imports` - Formatting
- `@types/google-apps-script` - Type definitions pro IntelliSense

**Features:**
- Bash safety: `set -euo pipefail`
- Logging do `/tmp/install-deps.log`
- Version verification po instalaci
- Error handling

**Permissions:**
- Executable: `chmod +x`

---

#### Script: `scripts/setup-project.sh`

**Účel:** Rychlé vytvoření nového Apps Script projektu z template

**Usage:**
```bash
./scripts/setup-project.sh <project-name> <template-type>
```

**Template types:**
- `standalone` - Basic automation script
- `sheets-addon` - Sheets add-on
- `webapp` - Web aplikace

**Co dělá:**
1. Validuje parametry
2. Zkontroluje že projekt neexistuje
3. Vytvoří directory v `projects/`
4. Zkopíruje template soubory
5. Nahradí placeholdery (PROJECT_NAME, DATE)
6. Vytvoří `README.md` s next steps

**Features:**
- Input validation
- Error handling
- Friendly output s next steps
- Executable: `chmod +x`

---

### 5. Documentation

#### `docs/README.md` - Documentation Index
- Přehled všech docs
- Quick links pro začátečníky
- External resources (Apps Script docs, clasp, style guides)

#### `docs/getting-started.md` - Getting Started Guide
**Obsah:**
- Prerequisites check (Node.js, npm, Git)
- Installation steps (`./scripts/install-deps.sh`)
- Clasp authentication (`clasp login`)
- První projekt (hello-world example)
- Development workflow (edit → lint → push → test)
- Time-based triggers setup
- Editor setup (Neovim, VS Code)
- Project templates overview
- Troubleshooting

**Length:** ~450 řádků, velmi detailed

#### `docs/clasp-workflow.md` - Clasp CLI Reference
**Obsah:**
- Complete clasp commands reference
- Project creation (všechny types)
- Clone existing projects
- Push/pull sync operations
- Conflict handling
- Deployment management (create, update, undeploy)
- Authentication (login, logout, service accounts)
- Configuration files (.clasp.json, .claspignore, appsscript.json)
- Advanced commands (versions, APIs, logs)
- Practical examples (automation, add-on, webapp)
- Troubleshooting

**Length:** ~650 řádků, comprehensive

#### `docs/eslint-prettier.md` - Code Quality Setup
**Obsah:**
- ESLint + Prettier purpose a benefits
- Configuration files explained
- Command line usage
- NPM scripts setup
- Editor integration (Neovim LSP, VS Code)
- Common rules explained with examples
- Custom rules a overrides
- Testing config
- Ignoring files (.eslintignore, .prettierignore)
- Troubleshooting

**Length:** ~500 řádků, detailed

#### `scripts/README.md` - Scripts Documentation
**Obsah:**
- Přehled utility skriptů
- `install-deps.sh` - co instaluje, usage
- `setup-project.sh` - usage, examples, output
- Development guidelines pro nové skripty
- Testing best practices

---

### 6. Changelog Structure

#### `changelog/README.md` - Changelog Index
- Formát changelog entries
- Historie změn (linkuje na jednotlivé entries)
- Typy změn (Initial Setup, Feature, Update, Fix, atd.)
- Template pro nový changelog entry

#### `changelog/2026-02-08-initial-setup.md` (tento soubor)
- Detailní popis initial setup
- Všechny vytvořené soubory a jejich účel
- Next steps
- Metadata

---

### 7. Git Repository Setup

#### Inicializace
```bash
cd ~/Git/gapps-workspace
git init
git branch -M main
```

#### Commits (provedené)

**Commit 1: Project structure and core files**
```
feat: initial project structure and core files

- Create directory structure (changelog/, config/, docs/, projects/, scripts/, templates/)
- Add README.md (project overview + quick start)
- Add LICENSE (MIT)
- Add .gitignore (node_modules, .clasp.json, credentials)
- Add AGENTS.md (AI agent guidelines for Apps Script development)
```

**Commit 2: Configuration and templates**
```
feat: add configuration files and project templates

Config files:
- .eslintrc.json (ESLint with Google style)
- .prettierrc (Prettier formatting rules)
- jsconfig.json (JavaScript IntelliSense)
- .claspignore (Clasp sync ignore patterns)

Templates:
- standalone/ (basic automation script)
- sheets-addon/ (Sheets add-on with menu + sidebar)
- webapp/ (web app with HTML UI)

Utility scripts:
- install-deps.sh (install clasp, eslint, prettier)
- setup-project.sh (create project from template)
```

**Commit 3: Documentation and changelog** (právě připravujeme)
```
docs: add comprehensive documentation and changelog

Documentation:
- docs/README.md (documentation index)
- docs/getting-started.md (complete setup guide)
- docs/clasp-workflow.md (clasp CLI reference)
- docs/eslint-prettier.md (code quality setup)
- scripts/README.md (utility scripts documentation)

Changelog:
- changelog/README.md (changelog index + template)
- changelog/2026-02-08-initial-setup.md (this file)
```

---

## ✅ Ověření

**Po dokončení setup:**

```bash
# 1. Directory structure
cd ~/Git/gapps-workspace
tree -L 2

# 2. Git status
git status
git log --oneline

# 3. File permissions (scripts jsou executable)
ls -la scripts/
# Expected: -rwxr-xr-x ... install-deps.sh
# Expected: -rwxr-xr-x ... setup-project.sh

# 4. Config files exist
ls -la config/
# Expected: .eslintrc.json, .prettierrc, jsconfig.json, .claspignore

# 5. Templates complete
ls -la templates/standalone/
ls -la templates/sheets-addon/
ls -la templates/webapp/

# 6. Documentation complete
ls -la docs/
# Expected: README.md, getting-started.md, clasp-workflow.md, eslint-prettier.md
```

---

## 🔍 Výhody a přínosy

### Lokální development
- ✅ Edit v preferovaném editoru (Neovim, VS Code)
- ✅ Git versioning a pull requests
- ✅ Code review před deployment
- ✅ Backup a historie změn

### Code quality
- ✅ Automatický linting (ESLint) - catch bugs early
- ✅ Konzistentní formatting (Prettier)
- ✅ Google style guide enforcement
- ✅ IntelliSense support

### Productivity
- ✅ Quick project setup z templates (1 příkaz)
- ✅ Automation skripty (instalace, setup)
- ✅ Ready-to-use templates pro common use cases
- ✅ Kompletní dokumentace

### Best practices
- ✅ Strukturovaný workspace
- ✅ Separation of concerns (každý projekt separate directory)
- ✅ Dokumentovaný workflow
- ✅ Changelog tracking

---

## 📝 Poznámky

### Security
- **KRITICKÉ:** `.clasp.json` obsahuje Script ID → MUSÍ být v .gitignore
- **KRITICKÉ:** `~/.clasprc.json` obsahuje OAuth token → NIKDY necommitovat
- Templates mají placeholder Script IDs → nahrazují se při `clasp create`

### Clasp authentication
- První použití vyžaduje `clasp login` (OAuth flow)
- Token je uložen v `~/.clasprc.json` (home directory)
- Pro multiple accounts: `clasp logout && clasp login`

### Project templates
- Templates jsou copyovány, ne symlinkovány
- Placeholdery: `{{PROJECT_NAME}}`, `{{DATE}}` (nahrazuje setup script)
- Každý template má vlastní README s specific instructions

### ESLint + Prettier
- Prettier má prioritu pro formatting
- ESLint kontroluje logiku a code quality
- Možné conflicts → řeší se pomocí `eslint-config-prettier`

### Apps Script limitations
- **Execution timeout:** 6 minut (per execution)
- **Daily quotas:** 
  - UrlFetchApp: 20,000 calls/day
  - Email: 100 emails/day (consumer), 1,500 (G Workspace)
  - Script runtime: 90 min/day (consumer), 6 hours (G Workspace)
- [Complete quotas](https://developers.google.com/apps-script/guides/services/quotas)

---

## 🚀 Další kroky

### Bezprostřední (dnes)

- [x] Commit dokumentace a changelog (commit 3)
- [ ] Install dependencies: `./scripts/install-deps.sh`
- [ ] Authenticate clasp: `clasp login`
- [ ] Create GitHub repository
- [ ] Push to GitHub: `git push -u origin main`
- [ ] Create test project: `./scripts/setup-project.sh hello-world standalone`
- [ ] Test full workflow (create → push → open → test)
- [ ] Commit test project (commit 4)

### Short-term (tento týden)

- [ ] Create real project (email automation, sheets tool, atd.)
- [ ] Test all templates (standalone, sheets-addon, webapp)
- [ ] Setup Neovim LSP pro Apps Script development
- [ ] Create example projects v `projects/` (ne jen hello-world)

### Long-term (budoucnost)

- [ ] Add more templates:
  - Forms add-on
  - Docs add-on
  - Gmail add-on
- [ ] Create testing framework (mock Apps Script APIs)
- [ ] CI/CD pipeline (auto-deploy on git push)
- [ ] Shared libraries (utility functions pro reuse)
- [ ] Documentation: common patterns a best practices
- [ ] Integration s Google Workspace MCP server (pokud bude používaný)

---

## 🔗 Reference

### Official Documentation
- [Google Apps Script](https://developers.google.com/apps-script)
- [Clasp CLI](https://github.com/google/clasp)
- [Apps Script Reference](https://developers.google.com/apps-script/reference)

### Style Guides
- [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html)
- [ESLint Rules](https://eslint.org/docs/rules/)
- [Prettier Options](https://prettier.io/docs/en/options.html)

### Tools
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)
- [Apps Script Quotas](https://developers.google.com/apps-script/guides/services/quotas)

### Related Projects
- `~/Git/google-workspace-mcp` - Google Workspace MCP server (local)
- `~/Git/OpenCode` - Parent project s AGENTS.md guidelines

---

## 📊 Metadata

- **Autor**: m4p1x (martin.pohl.cz@gmail.com)
- **Datum vytvoření**: 2026-02-08
- **Environment**: Fedora Silverblue 43, Toolbox `code`
- **Git branch**: `main`
- **Total commits (po commit 3)**: 3
- **Tags**: #initial-setup #google-apps-script #clasp #eslint #prettier #workspace #templates #documentation

---

## 📈 Statistiky projektu (po initial setup)

**Soubory vytvořené:**
- Core files: 4 (README, LICENSE, .gitignore, AGENTS.md)
- Config files: 4 (.eslintrc.json, .prettierrc, jsconfig.json, .claspignore)
- Templates: 11 souborů (3 templates × ~4 soubory)
- Scripts: 2 (install-deps.sh, setup-project.sh)
- Documentation: 5 (docs/README + 3 guides + scripts/README)
- Changelog: 2 (changelog/README + tento soubor)

**Total: ~28 souborů**

**Lines of code/documentation:**
- Documentation: ~2,000 řádků (getting-started + clasp-workflow + eslint-prettier)
- Scripts: ~150 řádků bash kódu
- Templates: ~200 řádků (Code.js + HTML)
- Config: ~100 řádků JSON

**Total: ~2,450 řádků**

---

**Dokončeno:** 2026-02-08  
**Next action:** Commit dokumentace → install dependencies → clasp login → GitHub setup
