# Google Sheets Add-on Template

Template pro Google Sheets add-ony s custom menu a sidebar UI.

## Použití

1. Vytvoř nový projekt:
   ```bash
   ./scripts/setup-project.sh expense-tracker sheets
   ```

2. Edit `Code.js` a `Sidebar.html`

3. Push do Google Apps Script:
   ```bash
   clasp push
   ```

4. Test v Sheets:
   ```bash
   clasp open
   ```

## Struktura

- `Code.js` - Backend logic (menu, data processing)
- `Sidebar.html` - Frontend UI (HTML/CSS/JavaScript)
- `appsscript.json` - Manifest s OAuth scopes

## Features

- **Custom Menu** - `onOpen()` trigger vytvoří menu
- **Sidebar UI** - HTML interface s komunikací server-side
- **Data Processing** - Práce s sheet daty
- **Error Handling** - Try-catch s user notifications

## OAuth Scopes

Add-on vyžaduje tyto scopes:
- `spreadsheets.currentonly` - Přístup k aktivnímu sheetu
- `script.container.ui` - Sidebar a menu UI

## Use Cases

- Custom formule a calculations
- Data import/export
- Report generation
- Data validation
- Workflow automation
