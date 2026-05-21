# Cursor Configuration

Settings synced to `~/.cursor/` via `./scripts/sync-configs.sh`.

## Playwright MCP Server

**Prerequisites:**
1. Install [Playwright Extension for Chrome](https://chromewebstore.google.com/detail/playwright-extension/mmlmfjhmonkocbjadbfplnigmagldckm) from Chrome Web Store
2. The extension enables CDP (Chrome DevTools Protocol) communication for browser automation

**Configuration:** `mcp.json` configures Playwright with:
- Browser: Chrome
- Extension mode enabled (requires the Chrome extension above)

**Use:** Once installed and configured, you can use Playwright browser tools in Claude Code / Cursor for web automation, testing, and screenshots.
