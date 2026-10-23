--!strict
-- Shows the GHOST REIGN welcome screen when the player joins.
-- Built in code (not StarterGui) so it is fully version-controlled and scales from phone to 4K.

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local Theme = require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("Theme"))

local FADE = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local WelcomeController = {}

-- Small instance factory. Returns `any` so callers can cast to the concrete class.
local function make(className: string, props: { [string]: any }, children: { any }?): any
	local instance: any = Instance.new(className)
	for key, value in props do
		instance[key] = value
	end
	if children then
		for _, child in children do
			child.Parent = instance
		end
	end
	return instance
end

local function label(name: string, text: string, font: Font, size: number, color: Color3, order: number)
	return make("TextLabel", {
		Name = name,
		Text = text,
		FontFace = font,
		TextSize = size,
		TextColor3 = color,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = order,
	})
end

local function bindScale(scale: UIScale)
	local function update()
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end
		local viewport = camera.ViewportSize
		local ref = Theme.ReferenceResolution
		local factor = math.min(viewport.X / ref.X, viewport.Y / ref.Y)
		scale.Scale = math.clamp(factor, Theme.MinScale, Theme.MaxScale)
	end
	update()
	local camera = Workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
	end
end

function WelcomeController:Start()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local enterButton = make("TextButton", {
		Name = "Enter",
		Text = "ENTER",
		FontFace = Theme.Fonts.Title,
		TextSize = 20,
		TextColor3 = Theme.Colors.Text,
		BackgroundColor3 = Theme.Colors.Accent,
		AutoButtonColor = true,
		Size = UDim2.fromOffset(220, 52),
		LayoutOrder = 5,
	}, {
		make("UICorner", { CornerRadius = UDim.new(0, 4) }),
	}) :: TextButton

	local content = make("Frame", {
		Name = "Content",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
	}, {
		make("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 14),
		}),
		label("Eyebrow", "CLASSIFIED // EYES ONLY", Theme.Fonts.Mono, 16, Theme.Colors.Accent, 1),
		label("Title", Config.GameName, Theme.Fonts.Title, 84, Theme.Colors.Text, 2),
		make("Frame", {
			Name = "Rule",
			Size = UDim2.fromOffset(360, 2),
			BackgroundColor3 = Theme.Colors.Accent,
			BorderSizePixel = 0,
			LayoutOrder = 3,
		}),
		label(
			"Subtitle",
			("Welcome, Operative %s. Clearance pending."):format(player.DisplayName),
			Theme.Fonts.Body,
			20,
			Theme.Colors.TextMuted,
			4
		),
		enterButton,
	})

	local scale = make("UIScale", {}) :: UIScale

	local root = make("Frame", {
		Name = "Root",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme.Colors.Backdrop,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
	}, {
		make("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.5, 0.35),
				NumberSequenceKeypoint.new(1, 0),
			}),
		}),
		scale,
		content,
		make("TextLabel", {
			Name = "Version",
			Text = ("v%s  ·  %s"):format(Config.Version, Config.Phase),
			FontFace = Theme.Fonts.Mono,
			TextSize = 12,
			TextColor3 = Theme.Colors.TextMuted,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -16, 1, -12),
			AutomaticSize = Enum.AutomaticSize.XY,
		}),
	}) :: Frame

	local screen = make("ScreenGui", {
		Name = "GhostReignWelcome",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 100,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}) :: ScreenGui

	bindScale(scale)

	-- Fade in.
	local canvas = make("CanvasGroup", {
		Name = "Fade",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
	}) :: CanvasGroup
	root.Parent = canvas
	canvas.Parent = screen
	screen.Parent = playerGui
	TweenService:Create(canvas, FADE, { GroupTransparency = 0 }):Play()

	-- Gamepad / console: select the button so the A button works immediately.
	if GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled then
		GuiService.SelectedObject = enterButton
	end

	local dismissed = false
	enterButton.Activated:Connect(function()
		if dismissed then
			return
		end
		dismissed = true
		if GuiService.SelectedObject == enterButton then
			GuiService.SelectedObject = nil
		end
		local tween = TweenService:Create(canvas, FADE, { GroupTransparency = 1 })
		tween.Completed:Once(function()
			screen:Destroy()
		end)
		tween:Play()
	end)
end

return WelcomeController
