# Clasp Workflow - Complete Guide

Kompletní reference pro práci s `clasp` CLI a Google Apps Script deployment.

---

## 🎯 Co je clasp?

**Clasp** (Command Line Apps Script Projects) je oficiální CLI tool od Google pro:
- ✅ Lokální vývoj Apps Script projektů
- ✅ Verzování pomocí git
- ✅ Push/pull sync s Google cloudem
- ✅ Deployment management
- ✅ Log viewing

---

## 🚀 Základní workflow

### Project lifecycle

```bash
# 1. Vytvoř nový projekt (Google cloud)
clasp create --type standalone --title "My Project"

# 2. Edit lokálně
nvim Code.js

# 3. Push do cloudu
clasp push

# 4. Test v editoru
clasp open

# 5. Pull změny (pokud editoval v browseru)
clasp pull

# 6. Deploy (pro web apps)
clasp deploy --description "v1.0.0"
```

---

## 📝 Project Creation

### Create new project

**Standalone script:**
```bash
clasp create --type standalone --title "My Automation"
```

**Sheets-bound script:**
```bash
clasp create --type sheets --title "My Add-on"
```

**Web app:**
```bash
clasp create --type webapp --title "My Web App"
```

**Docs-bound script:**
```bash
clasp create --type docs --title "My Doc Tool"
```

**Forms-bound script:**
```bash
clasp create --type forms --title "My Form Handler"
```

**Co se stane:**
- Vytvoří se nový Apps Script project v Google cloudu
- Vygeneruje se `.clasp.json` s Script ID
- Pro sheets/docs/forms se vytvoří i parent dokument

---

### Clone existing project

**1. Najdi Script ID:**
- Otevři Apps Script editor
- URL: `https://script.google.com/d/SCRIPT_ID/edit`
- Copy `SCRIPT_ID`

**2. Clone lokálně:**
```bash
clasp clone SCRIPT_ID
```

**NEBO vytvoř `.clasp.json` manually:**
```bash
echo '{"scriptId":"SCRIPT_ID"}' > .clasp.json
clasp pull
```

---

## 🔄 Sync Operations

### Push changes to cloud

**Basic push:**
```bash
clasp push
```

**Watch mode (auto-push):**
```bash
clasp push --watch
```
→ Automaticky pushne při každé změně souborů

**Force push (ignore conflicts):**
```bash
clasp push --force
```
⚠️ **WARNING:** Přepíše remote změny bez merge!

---

### Pull changes from cloud

**Basic pull:**
```bash
clasp pull
```

**Force pull (overwrite local):**
```bash
clasp pull --force
```
⚠️ **WARNING:** Přepíše lokální změny!

---

### Handling conflicts

**Scenario:** Edit v browseru + lokální změny

**Solution:**
```bash
# 1. Stash lokální změny (git)
git stash

# 2. Pull z cloudu
clasp pull

# 3. Apply stashed změny
git stash pop

# 4. Resolve conflicts manually
nvim Code.js

# 5. Push merged version
clasp push
```

---

## 🔍 Project Info

### Status check

```bash
clasp status
```

**Output:**
```
Not ignored files:
└─ Code.js
└─ appsscript.json

Ignored files:
└─ .clasp.json
└─ node_modules/
```

---

### List all projects

```bash
clasp list
```

**Output:**
```
# name – scriptId
My Project 1 - 1abc...xyz
My Project 2 - 2def...uvw
```

---

### Project info

```bash
clasp setting
```

**Output:**
```
Script ID: 1abc...xyz
Parent ID: (none)
Title: My Project
```

---

## 🌐 Opening & Viewing

### Open in editor

```bash
clasp open
```
→ Otevře Apps Script editor v browseru

**Open specific file:**
```bash
clasp open --addon
```
→ Otevře parent dokument (pro sheets/docs add-ons)

---

### View deployment

```bash
clasp open --webapp
```
→ Otevře deployed web app URL

---

### View logs

**Recent execution logs:**
```bash
clasp logs
```

**Watch logs (live):**
```bash
clasp logs --watch
```

**Filter by function:**
```bash
clasp logs --function myFunction
```

---

## 🚢 Deployment

### Deploy web app

**Create deployment:**
```bash
clasp deploy --description "v1.0.0 - Initial release"
```

**Output:**
```
Created version 1.
- AKfyc... @1 - v1.0.0 - Initial release
```

**Deployment ID** = `AKfyc...`

---

### List deployments

```bash
clasp deployments
```

**Output:**
```
2 Deployments:
- AKfyc... @1 - v1.0.0 - Initial release
- AKfyc... @HEAD - Latest version (test)
```

---

### Update deployment

```bash
# Push nové změny
clasp push

# Deploy jako nová verze
clasp deploy --deploymentId AKfyc... --description "v1.1.0 - Bug fixes"
```

---

### Undeploy (delete)

```bash
clasp undeploy AKfyc...
```

⚠️ **WARNING:** Smaže deployment - URL přestane fungovat!

---

### Deployment access control

**Nastavení v Apps Script editoru:**
1. `clasp open`
2. Deploy → Manage deployments
3. Vyber deployment → Edit
4. "Who has access":
   - **Only myself** - private, jen ty
   - **Anyone within [organization]** - internal, celá organizace
   - **Anyone** - public, kdokoliv s URL

---

## 🔐 Authentication

### Login

```bash
clasp login
```

**Co se stane:**
1. Otevře browser s OAuth flow
2. Přihlaš se Google účtem
3. Povol clasp permissions
4. Token → `~/.clasprc.json`

---

### Check current user

```bash
clasp whoami
```

**Output:**
```
You are logged in as: martin.pohl.cz@gmail.com
```

---

### Logout

```bash
clasp logout
```

**Použití:**
- Switch between Google accounts
- Token expired nebo authentication issues
- Security - odstraň token z shared machine

---

### Login with service account

**Use case:** CI/CD automation

```bash
clasp login --creds credentials.json
```

**credentials.json:**
- Download z Google Cloud Console
- Service Account s Apps Script API enabled

---

## ⚙️ Configuration

### .clasp.json

**Format:**
```json
{
  "scriptId": "1abc...xyz",
  "rootDir": "./src"
}
```

**Parametry:**
- `scriptId` - Google Apps Script project ID (required)
- `rootDir` - source directory (optional, default: `.`)
- `parentId` - parent dokument ID pro bound scripts (optional)

**Example s rootDir:**
```json
{
  "scriptId": "1abc...xyz",
  "rootDir": "./src"
}
```
→ Push pouze soubory z `./src/` directory

---

### .claspignore

**Účel:** Ignore soubory při push (similar to .gitignore)

**Default ignorované:**
```
**/**
!**/*.gs
!**/*.js
!**/*.html
!**/*.json
```

**Custom ignore:**
```
# .claspignore
node_modules/
.env
*.test.js
.git/
.clasp.json
```

---

### appsscript.json

**Manifest file** - metadata o Apps Script projektu

**Basic structure:**
```json
{
  "timeZone": "Europe/Prague",
  "dependencies": {
    "enabledAdvancedServices": []
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```

**Advanced services example:**
```json
{
  "timeZone": "Europe/Prague",
  "dependencies": {
    "enabledAdvancedServices": [
      {
        "userSymbol": "Drive",
        "serviceId": "drive",
        "version": "v3"
      }
    ]
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```

**Web app configuration:**
```json
{
  "timeZone": "Europe/Prague",
  "dependencies": {},
  "webapp": {
    "access": "ANYONE_ANONYMOUS",
    "executeAs": "USER_DEPLOYING"
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```

---

## 📊 Advanced Commands

### Versions

**Create version:**
```bash
clasp version "v1.0.0 - Major release"
```

**List versions:**
```bash
clasp versions
```

**Output:**
```
3 Versions:
1 - v1.0.0 - Initial release
2 - v1.1.0 - Bug fixes
3 - v2.0.0 - Major rewrite
```

---

### APIs

**List enabled APIs:**
```bash
clasp apis list
```

**Enable API:**
```bash
clasp apis enable drive
```

**Disable API:**
```bash
clasp apis disable drive
```

---

### Run function (EXPERIMENTAL)

```bash
clasp run functionName
```

⚠️ **Note:** Experimental feature, může nefungovat pro všechny funkce

---

## 🧰 Practical Examples

### Example 1: Daily automation

**Setup:**
```bash
# Vytvoř projekt
./scripts/setup-project.sh daily-report standalone
cd projects/daily-report

# Create + push
clasp create --type standalone --title "Daily Report"
clasp push
```

**Code.js:**
```javascript
function sendDailyReport() {
  const data = fetchYesterdayData();
  const report = generateReport(data);
  sendEmail(report);
  Logger.log('Daily report sent');
}

function fetchYesterdayData() {
  // Fetch data logic
}

function generateReport(data) {
  // Generate report logic
}

function sendEmail(report) {
  GmailApp.sendEmail(
    'team@example.com',
    'Daily Report',
    report
  );
}
```

**Setup trigger:**
1. `clasp open`
2. Triggers → Add Trigger
3. Function: `sendDailyReport`
4. Time-driven → Day timer → 9am to 10am

---

### Example 2: Sheets add-on

**Setup:**
```bash
./scripts/setup-project.sh data-importer sheets-addon
cd projects/data-importer

clasp create --type sheets --title "Data Importer"
clasp push
clasp open --addon
```

**Code.js:**
```javascript
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('Data Importer')
    .addItem('Import CSV', 'showImportDialog')
    .addToUi();
}

function showImportDialog() {
  const html = HtmlService.createHtmlOutputFromFile('ImportDialog')
    .setWidth(400)
    .setHeight(300);
  SpreadsheetApp.getUi().showModalDialog(html, 'Import CSV Data');
}

function importCsvData(csvUrl) {
  const response = UrlFetchApp.fetch(csvUrl);
  const csv = response.getContentText();
  const data = Utilities.parseCsv(csv);
  
  const sheet = SpreadsheetApp.getActiveSheet();
  sheet.getRange(1, 1, data.length, data[0].length).setValues(data);
  
  return `Imported ${data.length} rows`;
}
```

---

### Example 3: Web app dashboard

**Setup:**
```bash
./scripts/setup-project.sh analytics-dashboard webapp
cd projects/analytics-dashboard

clasp create --type webapp --title "Analytics Dashboard"
clasp push
clasp deploy --description "v1.0.0"
clasp deployments  # Get URL
```

**Code.js:**
```javascript
function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Analytics Dashboard')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

function getAnalyticsData() {
  // Fetch z Google Analytics API nebo database
  return {
    pageviews: 1542,
    users: 234,
    sessions: 567
  };
}
```

**Index.html:**
```html
<!DOCTYPE html>
<html>
<head>
  <title>Analytics Dashboard</title>
  <style>
    .metric { padding: 20px; border: 1px solid #ccc; }
  </style>
</head>
<body>
  <h1>Analytics Dashboard</h1>
  <div id="metrics"></div>
  
  <script>
    google.script.run
      .withSuccessHandler(displayMetrics)
      .getAnalyticsData();
    
    function displayMetrics(data) {
      document.getElementById('metrics').innerHTML = `
        <div class="metric">Pageviews: ${data.pageviews}</div>
        <div class="metric">Users: ${data.users}</div>
        <div class="metric">Sessions: ${data.sessions}</div>
      `;
    }
  </script>
</body>
</html>
```

---

## 🐛 Troubleshooting

### Problem: Push conflicts

**Error:** `Push failed: Conflict detected`

**Solution:**
```bash
clasp pull              # Get remote changes
# Resolve conflicts
clasp push              # Push merged version
```

---

### Problem: Script ID not found

**Error:** `Could not find script with ID: ...`

**Solution:**
```bash
# Verify Script ID
cat .clasp.json

# Check access permissions
clasp open  # Pokud se otevře, máš přístup

# NEBO clone znovu
clasp clone CORRECT_SCRIPT_ID
```

---

### Problem: Authentication expired

**Error:** `Error: Request failed with status code 401`

**Solution:**
```bash
clasp logout
clasp login
```

---

### Problem: Rate limit exceeded

**Error:** `Quota exceeded`

**Solution:**
- Apps Script má quota limits (6 min execution, 20k API calls/day)
- Check [Quotas](https://developers.google.com/apps-script/guides/services/quotas)
- Optimizuj kód nebo request G Suite Enterprise account

---

## 📚 Best Practices

### Version control

```bash
# .gitignore
.clasp.json          # Script ID je project-specific
~/.clasprc.json      # OAuth token NIKDY necommituj
node_modules/
.env
```

### Development workflow

1. **Edit lokálně** - použij editor s LSP support
2. **Lint před pushem** - `npm run lint`
3. **Format code** - `npm run format`
4. **Test v cloudu** - `clasp push && clasp open`
5. **Pull před dalším editováním** - `clasp pull`

### Deployment strategy

- **@HEAD deployment** - pro testing (auto-updates)
- **Versioned deployments** - pro production (stable URLs)
- **Semantic versioning** - `v1.0.0`, `v1.1.0`, `v2.0.0`

---

## 🔗 Resources

- [Clasp GitHub Repository](https://github.com/google/clasp)
- [Apps Script Quotas](https://developers.google.com/apps-script/guides/services/quotas)
- [Apps Script Execution API](https://developers.google.com/apps-script/api/how-tos/execute)

---

**Vytvořeno:** 2026-02-08  
**Autor:** m4p1x
