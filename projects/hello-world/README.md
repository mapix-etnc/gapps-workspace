# Standalone Apps Script Template

Basic template pro standalone Google Apps Script projekty.

## Použití

1. Vytvoř nový projekt pomocí setup skriptu:
   ```bash
   ./scripts/setup-project.sh my-automation standalone
   ```

2. Edit `Code.js` s vlastní logikou

3. Push do Google Apps Script:
   ```bash
   clasp push
   ```

4. Test v browseru:
   ```bash
   clasp open
   ```

## Struktura

- `Code.js` - Main logic
- `appsscript.json` - Manifest (timezone, runtime, dependencies)

## Triggers

Standalone skripty můžeš spouštět:
- **Manually** - přes Apps Script editor nebo API
- **Time-driven** - přes triggers (každou hodinu, denně, atd.)
- **Event-driven** - přes custom events

## Use Cases

- Email automation
- Data synchronization
- Report generation
- Scheduled maintenance tasks
- API integrations
