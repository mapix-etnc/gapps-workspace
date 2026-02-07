# Google Apps Script Workspace

Development environment pro Google Apps Script projekty s lokálním vývojem, ESLint/Prettier supportem a utility skripty.

## 🎯 Účel

Tento repozitář poskytuje **kompletní infrastrukturu** pro vývoj Google Apps Script projektů:

- 🚀 Lokální vývoj v oblíbeném editoru (Neovim, VS Code, atd.)
- 📝 Code quality enforcement (ESLint + Prettier)
- 🔧 Utility skripty pro rychlý project setup
- 📚 Templates a boilerplate kód
- 📖 Dokumentace best practices

## 🚀 Quick Start

### 1. Instalace dependencies

```bash
# Instaluj clasp, ESLint, Prettier a další dependencies
./scripts/install-deps.sh
```

### 2. Autentizace

```bash
# OAuth login do Google účtu
clasp login
```

### 3. Vytvoř nový projekt

```bash
# Vytvoř standalone projekt
./scripts/setup-project.sh my-automation standalone

# Nebo Sheets add-on
./scripts/setup-project.sh expense-tracker sheets

# Nebo webapp
./scripts/setup-project.sh custom-dashboard webapp
```

### 4. Development workflow

```bash
cd projects/my-automation

# Edit Code.js v editoru
nvim Code.js

# Push změny do Google Apps Script
clasp push

# Otevři v browseru pro testing
clasp open
```

## 📁 Struktura projektu

```
gapps-workspace/
├── changelog/          # Chronologické záznamy změn
├── config/             # Sdílené konfigurace (ESLint, Prettier, atd.)
├── docs/               # Dokumentace a návody
│   ├── getting-started.md
│   ├── clasp-workflow.md
│   └── examples/
├── projects/           # Aktivní Apps Script projekty
├── scripts/            # Utility skripty
│   ├── install-deps.sh
│   └── setup-project.sh
└── templates/          # Project templates
    ├── standalone/
    ├── sheets-addon/
    └── webapp/
```

## 📚 Dokumentace

- [Getting Started](docs/getting-started.md) - Kompletní průvodce pro začátek
- [Clasp Workflow](docs/clasp-workflow.md) - Detailní reference clasp příkazů
- [ESLint & Prettier](docs/eslint-prettier.md) - Code quality setup

## 🔧 Dostupné Templates

### Standalone Script
Nezávislé skripty pro automatizaci - běží manuálně nebo přes triggers.

**Use cases:** Email automation, data processing, scheduled jobs

### Sheets Add-on
Custom funkcionalita pro Google Sheets s menu a sidebar.

**Use cases:** Custom formule, data import/export, reporting tools

### Web App
Standalone web aplikace hostovaná na Google Apps Script.

**Use cases:** Dashboards, formuláře, custom UI

## 🛠️ Technologie

- **clasp** - Command Line Apps Script Projects
- **ESLint** - JavaScript linting (Google style guide)
- **Prettier** - Code formatting
- **Node.js** - Runtime pro development tools
- **Git** - Version control

## 📝 Development Guidelines

Viz [AGENTS.md](AGENTS.md) pro kompletní guidelines pro AI agenty a development pravidla.

## 🤝 Contributing

1. Vytvoř feature branch: `git checkout -b feature/new-feature`
2. Commituj změny: `git commit -m "feat: add new feature"`
3. Push branch: `git push origin feature/new-feature`
4. Vytvoř Pull Request

## 📄 License

MIT License - viz [LICENSE](LICENSE)

## 👤 Autor

**m4p1x**
- Email: martin.pohl.cz@gmail.com
- GitHub: [@m4p1x](https://github.com/m4p1x)

## 🔗 Reference

- [Google Apps Script Documentation](https://developers.google.com/apps-script)
- [Clasp Documentation](https://developers.google.com/apps-script/guides/clasp)
- [Apps Script API Reference](https://developers.google.com/apps-script/reference)

---

**Vytvořeno:** 2026-02-08  
**Poslední aktualizace:** 2026-02-08
