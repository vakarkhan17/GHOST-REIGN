--!strict
-- Loads every ModuleScript in a folder, then runs a two-step lifecycle:
--   1. Init()  — called on every module in order; set up state, no yielding.
--   2. Start() — called in its own thread once all modules are initialised.
-- Used by both the server (Services) and the client (Controllers).

local Loader = {}

type Lifecycle = {
	Init: ((self: any) -> ())?,
	Start: ((self: any) -> ())?,
}

local function sortedModules(folder: Instance): { ModuleScript }
	local list = {}
	for _, child in folder:GetChildren() do
		if child:IsA("ModuleScript") then
			table.insert(list, child)
		end
	end
	table.sort(list, function(a, b)
		return a.Name < b.Name
	end)
	return list
end

function Loader.load(folder: Instance, label: string): { [string]: Lifecycle }
	local loaded: { [string]: Lifecycle } = {}
	local order: { string } = {}

	for _, moduleScript in sortedModules(folder) do
		local ok, result = pcall(require, moduleScript)
		if ok and type(result) == "table" then
			loaded[moduleScript.Name] = result :: Lifecycle
			table.insert(order, moduleScript.Name)
		else
			warn(("[%s] failed to load %s: %s"):format(label, moduleScript.Name, tostring(result)))
		end
	end

	for _, name in order do
		local module = loaded[name]
		local init = module.Init
		if init then
			local ok, err = pcall(function()
				init(module)
			end)
			if not ok then
				warn(("[%s] %s.Init error: %s"):format(label, name, tostring(err)))
			end
		end
	end

	for _, name in order do
		local module = loaded[name]
		local start = module.Start
		if start then
			task.spawn(function()
				local ok, err = pcall(function()
					start(module)
				end)
				if not ok then
					warn(("[%s] %s.Start error: %s"):format(label, name, tostring(err)))
				end
			end)
		end
	end

	return loaded
end

return Loader
