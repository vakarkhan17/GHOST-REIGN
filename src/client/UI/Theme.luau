--!strict
-- Visual tokens for GHOST REIGN interfaces. Change colours and fonts here, not in controllers.

local Theme = {
	Colors = {
		Backdrop = Color3.fromRGB(6, 8, 11),
		Panel = Color3.fromRGB(14, 17, 22),
		Text = Color3.fromRGB(232, 235, 240),
		TextMuted = Color3.fromRGB(140, 148, 160),
		Accent = Color3.fromRGB(196, 32, 44),
	},
	Fonts = {
		Title = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy),
		Body = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
		Mono = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular),
	},
	-- Layout is authored at this resolution and scaled to the device by UIScale.
	ReferenceResolution = Vector2.new(1280, 720),
	MinScale = 0.55,
	MaxScale = 1.6,
}

return table.freeze(Theme)
