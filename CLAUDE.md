# CLAUDE.md — GHOST REIGN development rules

Read this before changing anything in this repository.

## Workflow
- **ChatGPT** is the architect: it writes phase requirements.
- **Claude Code** implements them in this repository.
- **Rojo** syncs `src/` into Roblox Studio. **GitHub** (`main`) is the source of truth.
- Work one phase at a time. Do not start the next phase until the user approves it.

## Non-negotiable rules
1. The public game title is always **GHOST REIGN** (read it from `src/shared/Config.luau`; never hard-code a variant).
2. All countries, organisations and the storyline are **fictional and original**. Do not use real nations, agencies, brands or people.
3. Keep a modular architecture: server code in `src/server`, client code in `src/client`, shared code in `src/shared`.
4. The server is authoritative. Never trust the client for damage, currency, inventory, or progression.
5. Target high-fidelity PC graphics that scale down cleanly to mobile (see "Performance" below).
6. Never overwrite existing work without checking it first. Check `git status` before and after changes.
7. Never commit credentials, Roblox cookies (`.ROBLOSECURITY`), API keys, tokens, private keys or `.env` files.
8. Never publish the game to Roblox without the user's explicit approval.
9. Avoid external dependencies unless they are clearly justified and recorded in `docs/DECISIONS.md`.
10. Record every significant technical decision in `docs/DECISIONS.md`.

## Code conventions
- Language: Luau with `--!strict` at the top of every file.
- Formatting: StyLua (`stylua.toml`, tabs, 110 columns). Linting: selene (`selene.toml`).
- File names: `PascalCase.luau`. Scripts: `init.server.luau`, `init.client.luau`.
- Server systems are `Services` (`src/server/Services/*.luau`); client systems are `Controllers`
  (`src/client/Controllers/*.luau`). Both are loaded by `src/shared/Loader.luau`.
- Each Service or Controller is a table that may expose `Init()` (setup, no yielding) and `Start()` (runs in its own thread).
- UI is built in code. Colours, fonts and scaling live in `src/client/UI/Theme.luau`.
- Remotes are created by the server and validated on every call (type, range, rate limit).

## Performance (PC → mobile)
- `Workspace.StreamingEnabled` stays on.
- Use `Lighting.Technology = Future`. Post-effects must look acceptable when the engine downgrades on mobile.
- Avoid per-frame work on the server. Use events over polling.
- Use UIScale and Theme reference resolution so UI fits phones through 4K.

## Before every commit
```powershell
stylua --check src
selene src
rojo build default.project.json -o build/GHOST_REIGN.rbxlx
git status
```
Commit messages: short imperative summary, for example `Add WelcomeController fade-out`.
