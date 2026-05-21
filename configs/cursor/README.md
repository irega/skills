# Cursor Configuration

Settings synced to `~/.cursor/` via `./scripts/sync-configs.sh`.

## Playwright MCP Server

### Prerequisites

1. Install [Playwright Extension for Chrome](https://chromewebstore.google.com/detail/playwright-extension/mmlmfjhmonkocbjadbfplnigmagldckm) from Chrome Web Store
2. Get your extension token (to skip connection dialog):
   - Open Chrome DevTools (F12)
   - Look for "Playwright" in the top menu
   - Copy the displayed token
   - Create `~/.env.local` (or use `/repo/.env.local` for this project):
     ```bash
     PLAYWRIGHT_MCP_EXTENSION_TOKEN=<your-token>
     ```
   - Run `./scripts/sync-configs.sh` to inject it into `~/.cursor/mcp.json`

### Configuration

`mcp.json` configures Playwright with:
- Browser: Chrome
- Extension mode enabled
- Token auto-injected from `.env.local` by sync script
