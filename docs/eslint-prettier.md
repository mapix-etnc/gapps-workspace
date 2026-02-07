# ESLint & Prettier Setup

Konfigurace a použití ESLint + Prettier pro Google Apps Script projekty.

---

## 🎯 Účel

**ESLint** = linting (code quality, best practices, chyby)  
**Prettier** = formatting (styl, whitespace, jednotná struktura)

**Kombinace:**
- ESLint kontroluje logiku a potenciální bugs
- Prettier fixuje formatting automaticky
- Společně zajišťují konzistentní a kvalitní kód

---

## ⚙️ Konfigurace

### ESLint - .eslintrc.json

**Lokace:** `config/.eslintrc.json` (global) + per-project override

**Global config:**
```json
{
  "env": {
    "es2021": true,
    "node": true,
    "googleappsscript/googleappsscript": true
  },
  "extends": ["eslint:recommended", "google"],
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["googleappsscript"],
  "rules": {
    "no-unused-vars": "warn",
    "no-console": "off",
    "require-jsdoc": "off",
    "max-len": ["error", {"code": 100}]
  },
  "globals": {
    "Logger": "readonly",
    "SpreadsheetApp": "readonly",
    "GmailApp": "readonly",
    "DriveApp": "readonly",
    "UrlFetchApp": "readonly",
    "Utilities": "readonly",
    "ScriptApp": "readonly",
    "PropertiesService": "readonly",
    "HtmlService": "readonly"
  }
}
```

**Co to znamená:**

**env:**
- `es2021` - podporuje moderní JavaScript (let, const, arrow functions)
- `googleappsscript` - přidává Apps Script globals

**extends:**
- `eslint:recommended` - základní ESLint pravidla
- `google` - Google JavaScript Style Guide

**rules:**
- `no-unused-vars: "warn"` - warning místo error pro unused vars
- `no-console: "off"` - povolí `console.log()` (používáme `Logger.log()`)
- `require-jsdoc: "off"` - JSDoc není povinný
- `max-len: 100` - max 100 znaků na řádek

**globals:**
- Definuje Apps Script globální objekty (SpreadsheetApp, GmailApp, atd.)
- `"readonly"` = nesmí se přepisovat

---

### Prettier - .prettierrc

**Lokace:** `config/.prettierrc`

**Config:**
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

**Co to znamená:**
- `semi: true` - vždy středník na konci statements
- `trailingComma: "es5"` - trailing comma v objects/arrays
- `singleQuote: true` - použij `'` místo `"`
- `printWidth: 100` - max délka řádku (match ESLint)
- `tabWidth: 2` - 2 spaces pro indent
- `useTabs: false` - spaces, ne tabs
- `arrowParens: "always"` - vždy závorky u arrow functions `(x) => x`
- `endOfLine: "lf"` - Unix line endings

---

## 🚀 Použití

### Command line

**ESLint check:**
```bash
# Check všech JS souborů
eslint .

# Check specific file
eslint Code.js

# Fix auto-fixable issues
eslint --fix Code.js
```

**Prettier format:**
```bash
# Format všech JS souborů
prettier --write "**/*.js"

# Format specific file
prettier --write Code.js

# Check formatting (no changes)
prettier --check Code.js
```

---

### NPM scripts

**Setup v package.json:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint --fix .",
    "format": "prettier --write \"**/*.js\"",
    "format:check": "prettier --check \"**/*.js\""
  }
}
```

**Použití:**
```bash
# Lint check
npm run lint

# Lint + auto-fix
npm run lint:fix

# Format all files
npm run format

# Check formatting
npm run format:check
```

---

### Pre-commit workflow

**Doporučený workflow:**
```bash
# 1. Edit kódu
nvim Code.js

# 2. Format
npm run format

# 3. Lint
npm run lint

# 4. Fix issues pokud jsou
npm run lint:fix

# 5. Push
clasp push
```

---

## 🔧 Editor Integration

### Neovim (s LSP)

**Plugin: null-ls (formatting + linting):**

**~/.config/nvim/lua/null-ls-config.lua:**
```lua
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- ESLint
    null_ls.builtins.diagnostics.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.code_actions.eslint.with({
      prefer_local = "node_modules/.bin",
    }),
    
    -- Prettier
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
    }),
  },
})
```

**Auto-format on save:**
```lua
-- ~/.config/nvim/lua/format-on-save.lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.js",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

**Keybindings:**
```lua
-- ~/.config/nvim/lua/keybindings.lua
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format file' })
vim.keymap.set('n', '<leader>l', '<cmd>!npm run lint<CR>', { desc = 'Run ESLint' })
```

---

### VS Code

**Extensions:**
1. **ESLint** (`dbaeumer.vscode-eslint`)
2. **Prettier** (`esbenp.prettier-vscode`)

**Settings (workspace nebo global):**

**.vscode/settings.json:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": ["javascript"],
  "prettier.requireConfig": true
}
```

**Co to dělá:**
- `formatOnSave` - auto-format při Ctrl+S
- `defaultFormatter` - použij Prettier
- `codeActionsOnSave` - auto-fix ESLint issues při save
- `eslint.validate` - enable ESLint pro JS
- `prettier.requireConfig` - vyžaduj `.prettierrc` (nepoužívej defaults)

---

## 📋 Common Rules Explained

### ESLint rules

**no-unused-vars (warn):**
```javascript
// ❌ Warning
const unusedVar = 123;

// ✅ OK
const usedVar = 123;
Logger.log(usedVar);
```

**max-len (error, 100 chars):**
```javascript
// ❌ Error (přes 100 znaků)
const longString = 'This is a very long string that exceeds the maximum line length of 100 characters';

// ✅ OK (breaknuto)
const longString = 
  'This is a very long string that exceeds ' +
  'the maximum line length of 100 characters';
```

**no-var (error):**
```javascript
// ❌ Error (použij const/let)
var x = 10;

// ✅ OK
const x = 10;
let y = 20;
```

**prefer-const (error):**
```javascript
// ❌ Error (x se nemění, mělo by být const)
let x = 10;
Logger.log(x);

// ✅ OK
const x = 10;
Logger.log(x);
```

---

### Prettier formatting

**Single quotes:**
```javascript
// ❌ Before
const name = "John";

// ✅ After
const name = 'John';
```

**Trailing commas:**
```javascript
// ❌ Before
const obj = {
  a: 1,
  b: 2
};

// ✅ After
const obj = {
  a: 1,
  b: 2,
};
```

**Arrow function parens:**
```javascript
// ❌ Before
const fn = x => x * 2;

// ✅ After
const fn = (x) => x * 2;
```

**Line length (100):**
```javascript
// ❌ Before (přes 100 chars)
const result = someLongFunctionName(param1, param2, param3, param4, param5, param6);

// ✅ After (formatted)
const result = someLongFunctionName(
  param1,
  param2,
  param3,
  param4,
  param5,
  param6
);
```

---

## 🎨 Custom Rules

### Disable rule per-file

**V kódu:**
```javascript
/* eslint-disable no-unused-vars */
const debugVar = 123;  // Won't trigger warning
/* eslint-enable no-unused-vars */
```

**Pro celý soubor:**
```javascript
/* eslint-disable no-unused-vars */

// Celý soubor má disabled no-unused-vars
const var1 = 1;
const var2 = 2;
```

---

### Disable rule per-line

```javascript
const unusedVar = 123;  // eslint-disable-line no-unused-vars

// NEBO
// eslint-disable-next-line no-unused-vars
const anotherUnusedVar = 456;
```

---

### Project-specific rules

**Vytvoř `.eslintrc.json` v project root:**
```json
{
  "extends": "../../config/.eslintrc.json",
  "rules": {
    "max-len": ["error", {"code": 120}],
    "no-unused-vars": "off"
  }
}
```

→ Overriduje global config pro tento projekt

---

## 🧪 Testing Config

### Verify ESLint setup

**Test file - `test.js`:**
```javascript
// Should trigger errors/warnings
var x = 10;  // no-var
const unusedVar = 123;  // no-unused-vars
const longLine = 'This is a very long line that exceeds the maximum line length of one hundred characters';  // max-len
```

**Run:**
```bash
eslint test.js
```

**Expected output:**
```
test.js
  1:1   error    Unexpected var, use let or const instead  no-var
  2:7   warning  'unusedVar' is assigned but never used    no-unused-vars
  3:1   error    Line exceeds 100 characters               max-len

✖ 3 problems (2 errors, 1 warning)
```

---

### Verify Prettier setup

**Test file - `test.js`:**
```javascript
// Before Prettier
const name="John";const age=30;const obj={a:1,b:2}
```

**Run:**
```bash
prettier --write test.js
```

**After:**
```javascript
// After Prettier
const name = 'John';
const age = 30;
const obj = { a: 1, b: 2 };
```

---

## 🐛 Troubleshooting

### Problem: ESLint not finding config

**Error:** `No ESLint configuration found`

**Solution:**
```bash
# Copy config do project root
cp config/.eslintrc.json .

# NEBO nastav v package.json
{
  "eslintConfig": {
    "extends": "./config/.eslintrc.json"
  }
}
```

---

### Problem: Prettier conflicts with ESLint

**Error:** ESLint a Prettier mají konfliktní rules

**Solution:**
```bash
# Install eslint-config-prettier (disables conflicting ESLint rules)
npm install -g eslint-config-prettier

# Update .eslintrc.json
{
  "extends": ["eslint:recommended", "google", "prettier"]
}
```

---

### Problem: Apps Script globals not recognized

**Error:** `'SpreadsheetApp' is not defined`

**Solution:**
```json
// .eslintrc.json
{
  "globals": {
    "SpreadsheetApp": "readonly",
    "GmailApp": "readonly",
    // Add more Apps Script globals
  }
}
```

---

## 📊 Ignoring Files

### .eslintignore

**Create `.eslintignore`:**
```
node_modules/
dist/
*.min.js
.clasp.json
appsscript.json
```

---

### .prettierignore

**Create `.prettierignore`:**
```
node_modules/
dist/
*.min.js
appsscript.json
```

---

## 🔗 Resources

- [ESLint Documentation](https://eslint.org/docs/latest/)
- [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html)
- [Prettier Documentation](https://prettier.io/docs/en/)
- [ESLint Rules Reference](https://eslint.org/docs/rules/)

---

**Vytvořeno:** 2026-02-08  
**Autor:** m4p1x
