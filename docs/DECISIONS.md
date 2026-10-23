# Technical decisions

Newest at the bottom. Each entry: decision, reason, consequences.

## D-001 — Rojo as the sync layer (Phase 0)
**Decision:** All code lives in `src/` and is synced into Studio with Rojo 7.7.1.
**Why:** Code is reviewable in Git, agents can edit files directly, and builds are reproducible.
**Consequence:** Code edited only inside Studio is overwritten on the next sync. Always edit the files.

## D-002 — Toolchain pinned with Rokit (Phase 0)
**Decision:** `rokit.toml` pins rojo 7.7.1, selene 0.32.0 and StyLua 2.6.0.
**Why:** Everyone (and every agent) gets the same versions. A Rokit folder already exists on the main dev machine.
**Consequence:** Update versions in one place and record the change here.

## D-003 — Services/Controllers with a shared Loader (Phase 0)
**Decision:** Server systems are Services, client systems are Controllers, loaded by `src/shared/Loader.luau`
with an `Init` then `Start` lifecycle. No framework dependency (Knit etc.).
**Why:** Clear server/client separation with no external dependency, and one failing module cannot block the others.
**Consequence:** Cross-module dependencies are resolved with plain `require`. Revisit if this grows unwieldy.

## D-004 — UI built in code (Phase 0)
**Decision:** UI is constructed in Luau controllers using tokens from `UI/Theme.luau`, scaled with `UIScale` from a
1280×720 reference resolution (clamped 0.55–1.6).
**Why:** Fully diff-able in Git, consistent styling, works from phones to 4K.
**Consequence:** Complex layouts may later move to `.rbxm` models built in Studio. Record that if it happens.

## D-005 — Graphics baseline (Phase 0)
**Decision:** `Lighting.Technology = Future`, Atmosphere, Bloom, ColorCorrection and SunRays, dusk `ClockTime 18.4`.
`Workspace.StreamingEnabled = true`.
**Why:** Cinematic look on PC. Roblox automatically lowers lighting quality on low-end and mobile devices, and
streaming keeps memory under control on mobile.
**Consequence:** Any per-device graphics options will be a client Controller in a later phase.

## D-006 — Environment defined in the project file (Phase 0)
**Decision:** The Phase 0 ground, spawn and pillars are declared in `default.project.json`.
**Why:** Keeps the minimal place reproducible from Git alone.
**Consequence:** Real maps will be built in Studio and saved as `.rbxm` models under a future `assets/` folder,
added to the Rojo tree with their own decision entry.

## D-007 — Line endings (Phase 0)
**Decision:** `.gitattributes` forces LF for text and marks Roblox binary formats as binary.
**Why:** Avoids CRLF noise between Windows Git, Rojo and cloud agents.
