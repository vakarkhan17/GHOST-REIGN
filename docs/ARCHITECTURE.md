# Architecture

## Repository layout

```
GHOST REIGN/
├── default.project.json      Rojo project: maps src/ into the Roblox DataModel
├── rokit.toml                Pinned tool versions (rojo, selene, stylua)
├── selene.toml               Lint config (Roblox standard library)
├── stylua.toml               Formatter config
├── CLAUDE.md                 Development rules
├── README.md
├── docs/
│   ├── ARCHITECTURE.md       This file
│   ├── DECISIONS.md          Technical decision log
│   └── SETUP.md              Tooling and Studio connection
├── scripts/
│   └── check.ps1             Format, lint and build checks
└── src/
    ├── server/               → ServerScriptService.Server (Script)
    │   ├── init.server.luau  Server bootstrap
    │   └── Services/         Server systems (empty in Phase 0)
    ├── client/               → StarterPlayer.StarterPlayerScripts.Client (LocalScript)
    │   ├── init.client.luau  Client bootstrap
    │   ├── Controllers/
    │   │   └── WelcomeController.luau
    │   └── UI/
    │       └── Theme.luau    Colours, fonts, UI scaling
    └── shared/               → ReplicatedStorage.Shared
        ├── Config.luau       Game name, version, phase
        └── Loader.luau       Service/Controller lifecycle loader
```

## DataModel mapping

| Source | Studio location | Type |
|---|---|---|
| `src/server` | `ServerScriptService.Server` | Script |
| `src/client` | `StarterPlayer.StarterPlayerScripts.Client` | LocalScript |
| `src/shared` | `ReplicatedStorage.Shared` | Folder |
| project file | `Workspace.Environment` | Ground, SpawnPad, 4 pillars |
| project file | `Lighting` | Future lighting, Atmosphere, Bloom, ColorGrade, SunRays |

Instances defined only in `default.project.json` (Workspace, Lighting) use Rojo's default
`$ignoreUnknownInstances`, so anything you build by hand in Studio under those services is **not** deleted by `rojo serve`.
Hand-built map work still has to be saved into the repository (see DECISIONS.md, D-006).

## Startup sequence
1. `Server` script requires `Shared.Loader` and loads every ModuleScript in `Server.Services`.
2. `Client` LocalScript does the same for `Client.Controllers`.
3. The Loader requires modules alphabetically, calls every `Init()`, then calls each `Start()` in its own thread.
   Failures are caught and reported with `warn` so one broken module cannot stop the others.

## Adding a system
- Server: create `src/server/Services/NameService.luau` returning a table with optional `Init`/`Start`.
- Client: create `src/client/Controllers/NameController.luau` the same way.
- Shared types, constants and pure functions go in `src/shared`.
