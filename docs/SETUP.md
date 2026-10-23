# Setup (Windows)

## Toolchain
Tool versions are pinned in `rokit.toml`. [Rokit](https://github.com/rojo-rbx/rokit) installs them per project.

| Tool | Version | Purpose |
|---|---|---|
| Rojo | 7.7.1 | Sync files ↔ Studio, build place files |
| selene | 0.32.0 | Linter |
| StyLua | 2.6.0 | Formatter |
| Git | any recent | Source control |
| Roblox Studio | latest | Editor and playtesting |

```powershell
cd "C:\Users\vakar\Documents\Vakar\Claude New\Roblox\GHOST REIGN"
rokit install          # first time, or after rokit.toml changes
rojo --version         # expect: Rojo 7.7.1
```

If `rokit` is not installed, download it from its GitHub releases page and run `rokit self-install`.
Restart the terminal afterwards so the new PATH entry is picked up.

## Rojo Studio plugin
Install it once with:
```powershell
rojo plugin install
```
This writes the plugin into your Studio plugins folder (no admin rights needed). Restart Studio afterwards.
The plugin version must match the Rojo CLI major/minor version (7.7).

## Connecting Studio
1. `rojo serve` in the project folder (leave it running).
2. Studio → open a Baseplate place → **Plugins** tab → **Rojo** → **Connect**.
3. Delete the default `Baseplate` part under Workspace. The repo provides its own `Environment`.
4. Press **Play** and check the Output window for the two "ready" lines.

## Git
```powershell
git config --global core.autocrlf false   # .gitattributes already normalises to LF
git remote -v                             # origin → https://github.com/vakarkhan17/GHOST-REIGN.git
```
