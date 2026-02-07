# Web App Template

Template pro standalone web aplikace hostované na Google Apps Script.

## Použití

1. Vytvoř nový projekt:
   ```bash
   ./scripts/setup-project.sh custom-dashboard webapp
   ```

2. Edit `Code.js` (backend) a `Index.html` (frontend)

3. Push do Google Apps Script:
   ```bash
   clasp push
   ```

4. Deploy jako web app:
   ```bash
   clasp deploy --description "Production v1.0"
   ```

5. Získej web app URL:
   ```bash
   clasp deployments
   ```

## Struktura

- `Code.js` - Backend logic (doGet, doPost, API functions)
- `Index.html` - Frontend UI (HTML/CSS/JavaScript)
- `appsscript.json` - Manifest s webapp config a scopes

## Features

- **doGet()** - Handle GET requests (zobrazí stránku)
- **doPost()** - Handle POST requests (API endpoint)
- **google.script.run** - Client-server communication
- **Responsive Design** - Mobile-friendly UI
- **Modern UI** - Gradient background, clean design

## Deployment

Web app má dvě verze:
- **Test deployment** - Pro testování, URL se nemění
- **Production deployment** - Immutable verze s novým URL

```bash
# Test deployment (development)
clasp deploy --description "Test version"

# Production deployment
clasp version "v1.0.0"
clasp deploy --description "Production v1.0.0"
```

## Access Control

V `appsscript.json` nastav webapp.access:
- `ANYONE` - Kdokoliv s Google účtem
- `ANYONE_ANONYMOUS` - Kdokoliv včetně anonymních uživatelů
- `DOMAIN` - Pouze users z tvé G Suite domény
- `MYSELF` - Pouze ty

## Use Cases

- Custom dashboards
- Data visualization
- Form submissions
- Public APIs
- Interactive tools
- Landing pages
