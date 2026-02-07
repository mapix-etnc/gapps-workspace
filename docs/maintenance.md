# Maintenance Guide - Udržování workspace aktuální

Návod jak pravidelně aktualizovat dependencies, tools a workspace.

---

## 🔄 Pravidelná údržba

### Quick Update Check

**Spusť update script:**
```bash
cd ~/Git/gapps-workspace
./scripts/update-workspace.sh
```

**Co dělá:**
- ✅ Zkontroluje globální tools (clasp)
- ✅ Najde outdated npm packages
- ✅ Spustí security audit
- ✅ Zkontroluje git status (uncommitted changes, remote sync)
- ✅ Zobrazí summary s doporučenými akcemi

**Doporučená frekvence:** 1× měsíčně nebo před začátkem nového projektu

---

## 📦 Update Dependencies

### Lokální NPM packages (v workspace)

**Check outdated packages:**
```bash
cd ~/Git/gapps-workspace
npm outdated
```

**Output example:**
```
Package               Current  Wanted  Latest
eslint                8.57.0   8.57.1  10.0.0
prettier              3.8.0    3.8.1   3.8.1
eslint-config-google  0.14.0   0.14.0  0.15.0
```

**Legend:**
- **Current** - aktuálně nainstalovaná verze
- **Wanted** - nejnovější verze splňující semver v package.json (^, ~)
- **Latest** - nejnovější publikovaná verze (může mít breaking changes)

---

### Update strategie

**1. Safe update (minor/patch only):**
```bash
npm update
```
→ Updatene na **Wanted** verze (respektuje semver ranges)

**2. Latest versions (včetně major):**
```bash
npm update --latest
```
⚠️ **WARNING:** Může přinést breaking changes! Test po update.

**3. Specific package:**
```bash
npm update eslint
npm update prettier
```

**4. Interactive update (doporučeno):**
```bash
# Install npx tool
npm install -g npm-check-updates

# Check updates
npx npm-check-updates

# Interactive mode
npx npm-check-updates -i

# Update all to latest
npx npm-check-updates -u
npm install
```

---

### Po update - ověření

**1. Test ESLint:**
```bash
npm run lint
# Pokud selhává → check breaking changes v release notes
```

**2. Test Prettier:**
```bash
npm run format:check
# Pokud formatting se změnil → npm run format pro reformat
```

**3. Test na hello-world:**
```bash
cd projects/hello-world
npm run lint
npm run format
# Vše by mělo fungovat
```

---

## 🛠️ Update Globálních Tools

### Clasp (Google Apps Script CLI)

**Check version:**
```bash
clasp --version
```

**Update:**
```bash
npm install -g @google/clasp
```

**Ověření:**
```bash
clasp --version
clasp whoami  # Should still show your account
```

**Pokud login selhal po update:**
```bash
clasp logout
clasp login
```

---

### Node.js a npm

**Check versions:**
```bash
node --version   # v16+ doporučeno
npm --version    # v7+ doporučeno
```

**Update npm (v toolboxu):**
```bash
npm install -g npm@latest
```

**Update Node.js (v toolboxu):**
```bash
# Fedora toolbox
sudo dnf update nodejs npm

# Nebo použij nvm (doporučeno pro version management)
# https://github.com/nvm-sh/nvm
```

---

## 🔒 Security Audit

### NPM Audit

**Run audit:**
```bash
cd ~/Git/gapps-workspace
npm audit
```

**Output:**
```
found 3 vulnerabilities (1 moderate, 2 high)
  run `npm audit fix` to fix them
```

**Auto-fix (safe):**
```bash
npm audit fix
```
→ Opraví vulnerabilities bez breaking changes

**Force fix (may break):**
```bash
npm audit fix --force
```
⚠️ **WARNING:** Může updateovat na major versions! Test po použití.

**Pokud audit fix nepomůže:**
1. Čti detaily: `npm audit`
2. Check if package má update: `npm outdated`
3. Manual update: `npm update package-name@latest`
4. Pokud není fix → check GitHub issues, zvažit alternativní package

---

## 🔄 Update Templates

Templates (v `templates/`) jsou statické - pokud updatuješ dependencies, update i templates:

**1. Update config files:**
```bash
# ESLint config
cp config/.eslintrc.json templates/standalone/
cp config/.eslintrc.json templates/sheets-addon/
cp config/.eslintrc.json templates/webapp/

# Prettier config
cp config/.prettierrc templates/standalone/
cp config/.prettierrc templates/sheets-addon/
cp config/.prettierrc templates/webapp/
```

**2. Test template:**
```bash
./scripts/setup-project.sh test-template standalone
cd projects/test-template
npm run lint
npm run format
# Pokud OK → smaž test project
```

**3. Commit changes:**
```bash
git add templates/
git commit -m "chore: update templates with latest config"
```

---

## 📚 Update Dokumentace

Když updateuješ dependencies nebo workflow, update i docs:

**Files k update:**
- `docs/getting-started.md` - pokud se změnil install process
- `docs/eslint-prettier.md` - pokud se změnila konfigurace
- `docs/clasp-workflow.md` - pokud clasp přidal nové features
- `scripts/README.md` - pokud updatuješ skripty

**Changelog:**
```bash
# Vytvoř nový changelog entry
vim changelog/YYYY-MM-DD-update-dependencies.md

# Template viz changelog/README.md
```

---

## 🐛 Troubleshooting Updates

### Problem: ESLint selhává po update

**Error:** `Error: Failed to load config "google"`

**Solution:**
```bash
# Reinstall eslint config
npm install --save-dev eslint-config-google

# Verify
npm list eslint-config-google
```

---

### Problem: Prettier formatting se změnil

**Issue:** Po update prettier formátuje kód jinak

**Solution:**
1. Check `.prettierrc` - verify rules
2. Reformat celý workspace:
   ```bash
   npm run format
   git diff  # Review changes
   git add . && git commit -m "style: reformat with prettier X.Y.Z"
   ```

---

### Problem: Clasp přestal fungovat

**Error:** `Error: Invalid credentials`

**Solution:**
```bash
# Re-authenticate
clasp logout
clasp login

# Verify
clasp whoami
```

---

### Problem: npm packages v konfliktu

**Error:** `ERESOLVE unable to resolve dependency tree`

**Solution 1 - Force install:**
```bash
npm install --legacy-peer-deps
```

**Solution 2 - Clean reinstall:**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Solution 3 - Downgrade problematic package:**
```bash
# Example: downgrade ESLint
npm install --save-dev eslint@8
```

---

## 📅 Maintenance Checklist

### Měsíční (doporučeno)

- [ ] Run `./scripts/update-workspace.sh`
- [ ] Check npm outdated: `npm outdated`
- [ ] Run security audit: `npm audit`
- [ ] Pull from GitHub: `git pull`
- [ ] Check clasp version: `clasp --version`

### Před novým projektem

- [ ] Run update script
- [ ] Update dependencies: `npm update`
- [ ] Test lint/format: `npm run lint && npm run format`
- [ ] Verify clasp works: `clasp whoami`

### Po major dependency update

- [ ] Test všech templates (standalone, sheets-addon, webapp)
- [ ] Update dokumentace pokud se workflow změnil
- [ ] Create changelog entry
- [ ] Commit a push changes

### Quarterly (čtvrtletně)

- [ ] Review a update documentation
- [ ] Check for deprecated packages: `npm outdated`
- [ ] Consider upgrading to latest major versions
- [ ] Backup workspace: `tar -czf gapps-workspace-backup-$(date +%F).tar.gz ~/Git/gapps-workspace`

---

## 🚀 Automation (volitelné)

### Git pre-commit hook (auto-lint)

**Setup:**
```bash
# Install husky
cd ~/Git/gapps-workspace
npm install --save-dev husky lint-staged

# Initialize
npx husky init

# Add pre-commit hook
cat > .husky/pre-commit << 'EOF'
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
EOF

chmod +x .husky/pre-commit
```

**Config v package.json:**
```json
{
  "lint-staged": {
    "**/*.js": [
      "eslint --fix",
      "prettier --write"
    ]
  }
}
```

→ Automaticky lint + format před každým commitem

---

### Cron job pro monthly update check

**Setup (Fedora toolbox):**
```bash
# Edit crontab
crontab -e

# Add monthly check (1st day of month, 9am)
0 9 1 * * cd ~/Git/gapps-workspace && ./scripts/update-workspace.sh
```

---

## 📖 Resources

**NPM:**
- [npm-check-updates](https://www.npmjs.com/package/npm-check-updates) - Interactive update tool
- [npm audit docs](https://docs.npmjs.com/cli/v8/commands/npm-audit)
- [Semantic Versioning](https://semver.org/)

**Dependencies:**
- [ESLint Releases](https://github.com/eslint/eslint/releases)
- [Prettier Changelog](https://github.com/prettier/prettier/blob/main/CHANGELOG.md)
- [Clasp Releases](https://github.com/google/clasp/releases)

**Security:**
- [npm Security Advisories](https://github.com/advisories)
- [Snyk Vulnerability DB](https://snyk.io/vuln/)

---

## 💡 Best Practices

**1. Test updates v safe prostředí:**
```bash
# Vytvoř test branch
git checkout -b test-updates

# Update
npm update --latest
npm audit fix

# Test
npm run lint
npm run format

# Pokud OK → merge
git checkout main
git merge test-updates

# Pokud selhal → discard
git checkout main
git branch -D test-updates
```

**2. Pin critical versions:**

Pokud specific verze je kritická, pin ji v `package.json`:
```json
{
  "devDependencies": {
    "eslint": "8.57.1",  // Exact version (no ^)
    "prettier": "^3.8.0"  // Allow minor/patch
  }
}
```

**3. Document breaking changes:**

V changelogu zaznamenej:
- Co se update změnilo
- Proč byl update nutný
- Jak migrovat existující projekty

**4. Keep backup:**

Před major updates:
```bash
cd ~/Git/gapps-workspace
git tag -a backup-before-major-update -m "Backup before ESLint v9 → v10"
git push origin --tags
```

---

**Vytvořeno:** 2026-02-08  
**Autor:** m4p1x  
**Poslední update:** 2026-02-08
