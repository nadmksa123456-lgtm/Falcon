--[[
	TRust Menu - executor-ready script template

	The feature categories intentionally start empty. Add each script's tabs,
	sections, and controls through the returned API tables.
]]

local DEFAULT_RAW_BASE = "https://raw.githubusercontent.com/nadmksa123456-lgtm/TRust-hub/refs/heads/main"
local environment = type(getgenv) == "function" and getgenv() or _G
local rawBase = tostring(environment.TRUST_MENU_BASE_URL or DEFAULT_RAW_BASE):gsub("/+$", "")

environment.TRUST_MENU_BASE_URL = rawBase

local compiler = environment.loadstring or loadstring
assert(type(compiler) == "function", "[TRust Menu] loadstring is unavailable in this executor")

local loaderSource = game:HttpGet(rawBase .. "/loader.lua")
local Library = compiler(loaderSource, "@TRust-Menu/loader.lua")()

local Window = Library:CreateWindow({
	Name = "TRust Menu",
	NotifyTitle = "Talon Script",
	NotificationWidth = 340,
	Size = Vector2.new(1000, 620),
	ThemeColor = Color3.fromRGB(255, 5, 126),
	ToggleKey = Enum.KeyCode.Insert,
	ShowBrandName = false,
})

local Categories = {}
local Tabs = {}
local Sections = {}
local Controls = {}

Categories.Main = Window:AddCategory({
	Name = "Main",
	Icon = Library:GetIcon(1),
	Symbol = "M",
	Order = 1,
})

Categories.Targeting = Window:AddCategory({
	Name = "Targeting",
	Icon = Library:GetIcon(2),
	Symbol = "T",
	Order = 2,
})

Categories.Visuals = Window:AddCategory({
	Name = "Visuals",
	Icon = Library:GetIcon(3),
	Symbol = "V",
	Order = 3,
})

Categories.Players = Window:AddCategory({
	Name = "Players",
	Icon = Library:GetIcon(4),
	Symbol = "P",
	Order = 4,
})

Categories.Settings = Window:AddCategory({
	Name = "Settings",
	Icon = Library:GetIcon(5),
	Symbol = "S",
	Order = 5,
})

-- Build the permanent settings while its page is visible. This keeps layout
-- measurements reliable in executors, then Main is restored as the start page.
Categories.Settings:Select()
Tabs.Settings = Categories.Settings:AddTab({Name = "Settings", Order = 1})
Sections.MenuSettings = Tabs.Settings:AddSection({Name = "Menu Settings", Column = 1, Order = 1})
Sections.Settings = Sections.MenuSettings

Controls.MenuColor = Sections.MenuSettings:AddColorPicker({
	Text = "Menu Color",
	Flag = "menu_color",
	Order = 1,
	Default = Color3.fromRGB(255, 5, 126),
	ApplyToTheme = true,
	Continuous = true,
})

Controls.MenuOpacity = Sections.MenuSettings:AddSlider({
	Text = "Menu Opacity",
	Flag = "menu_opacity",
	Order = 2,
	Min = 20,
	Max = 100,
	Step = 1,
	Default = 100,
	Suffix = "%",
	Callback = function(value)
		Window:SetOpacity(value, true)
	end,
})

Controls.MenuKey = Sections.MenuSettings:AddKeybind({
	Text = "Menu Key",
	Flag = "menu_key",
	Order = 3,
	Default = Enum.KeyCode.Insert,
	Mode = "Press",
	-- Only OnChanged is used. The window already listens for its own toggle
	-- key, so giving this control a Callback too would toggle twice per press.
	OnChanged = function(key)
		Window:SetToggleKey(key)
	end,
})

Controls.MenuBlur = Sections.MenuSettings:AddToggle({
	Text = "Background Blur",
	Flag = "menu_blur",
	Order = 5,
	Default = true,
	Notify = false,
	Callback = function(state)
		Window:SetBlurEnabled(state)
	end,
})

Controls.BlurIntensity = Sections.MenuSettings:AddSlider({
	Text = "Blur Amount",
	Flag = "menu_blur_amount",
	Order = 6,
	Min = 0,
	Max = 100,
	Default = 70,
	Suffix = "%",
	-- Glass density runs 0.90 (heaviest) to 0.995 (barely there), so the slider
	-- is inverted: a higher percentage means a stronger blur.
	Callback = function(value)
		Window:SetBlurStrength(0.995 - (value / 100) * 0.095)
	end,
})

Controls.MenuButton = Sections.MenuSettings:AddToggle({
	Text = "Menu Button",
	Flag = "menu_button",
	Order = 4,
	Default = true,
	-- The menu's own controls stay silent; notifications are for gameplay features.
	Notify = false,
	Callback = function(state)
		Window:SetLauncherVisible(state)
	end,
})

local function refreshMenuSettings()
	Controls.MenuColor.Row.Visible = true
	Controls.MenuOpacity.Row.Visible = true
	Controls.MenuKey.Row.Visible = true
	Controls.MenuButton.Row.Visible = true
	Controls.MenuBlur.Row.Visible = true
	Controls.BlurIntensity.Row.Visible = true
	Sections.MenuSettings:Refresh()
	Tabs.Settings:RefreshCanvas()
end

refreshMenuSettings()
task.defer(refreshMenuSettings)
task.delay(0.1, refreshMenuSettings)

-- Standing Discord invite. Fires 30 seconds after load so it is not competing
-- with the menu opening, then repeats every 10 minutes for as long as the menu
-- is alive. TextSize is stepped down so the full link fits without truncating.
Window:NotifyRepeating({
	Title = "Join my Discord",
	Text = "https://discord.gg/sNZSpTNjFs",
	Duration = 10,
	Interval = 600,
	StartDelay = 30,
	TextSize = 13,
})

-- Start on the empty Main category, ready for the consuming script to add UI.
Categories.Main:Select()

return {
	Library = Library,
	Window = Window,
	Categories = Categories,
	Tabs = Tabs,
	Sections = Sections,
	Controls = Controls,
}
