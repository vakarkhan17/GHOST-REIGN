# GHOST REIGN

A premium cinematic espionage experience for Roblox, set in a world of fictional nations and an original storyline.

**Status:** Phase 0 — development environment. No gameplay yet.

## Quick start (Windows)

```powershell
# 1. Install the pinned toolchain (Rojo, selene, StyLua) with Rokit
rokit install

# 2. Check the code and build a place file
stylua --check src
selene src
rojo build default.project.json -o build/GHOST_REIGN.rbxlx

# 3. Live-sync into Roblox Studio
rojo serve
```

Then, in Roblox Studio: open a Baseplate place, open the **Rojo** plugin and click **Connect** (default `localhost:34872`).
Press **Play**. You should see the GHOST REIGN welcome screen and these Output lines:

```
[GHOST REIGN] server ready — v0.1.0
[GHOST REIGN] client ready — v0.1.0
```

You can also open `build/GHOST_REIGN.rbxlx` directly in Studio.

## Documentation
- [`CLAUDE.md`](CLAUDE.md): development rules
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): project structure and how code is loaded
- [`docs/SETUP.md`](docs/SETUP.md): tool installation and Studio connection
- [`docs/DECISIONS.md`](docs/DECISIONS.md): technical decision log
