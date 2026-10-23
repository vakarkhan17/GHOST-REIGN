--!strict
-- GHOST REIGN client bootstrap.
-- Client controllers live in ./Controllers and are loaded by the shared Loader.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Loader = require(Shared:WaitForChild("Loader"))

Loader.load(script:WaitForChild("Controllers"), "Client")

print(("[%s] client ready — v%s"):format(Config.GameName, Config.Version))
