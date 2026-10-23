--!strict
-- GHOST REIGN server bootstrap.
-- Gameplay services live in ./Services and are loaded by the shared Loader.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Loader = require(Shared:WaitForChild("Loader"))

Loader.load(script:WaitForChild("Services"), "Server")

print(("[%s] server ready — v%s"):format(Config.GameName, Config.Version))
