--!strict
-- Shared, read-only configuration for GHOST REIGN.
-- Replicated to both server and client. Never put secrets here.

local Config = {
	GameName = "GHOST REIGN",
	Version = "0.1.0",
	Phase = "Phase 0 — Environment",
}

return table.freeze(Config)
