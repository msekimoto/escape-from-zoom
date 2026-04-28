local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("CharacterRemotes"):WaitForChild("SelectCharacter")

local characters = {
	{ Name = "Momo", Role = "Mobilidade", Color = Color3.fromRGB(255, 222, 89), Emoji = "🐒" },
	{ Name = "Porinha", Role = "Suporte", Color = Color3.fromRGB(255, 150, 200), Emoji = "🐷" },
	{ Name = "Leon", Role = "Controle", Color = Color3.fromRGB(255, 185, 80), Emoji = "🦁" },
	{ Name = "Elly", Role = "Tanque", Color = Color3.fromRGB(160, 200, 255), Emoji = "🐘" },
	{ Name = "Snapper", Role = "Furtivo", Color = Color3.fromRGB(120, 255, 150), Emoji = "🐊" },
	{ Name = "Grumblet", Role = "Disruptor", Color = Color3.fromRGB(255, 95, 95), Emoji = "🦜" },
}

local selected = "Momo"

local gui = Instance.new("ScreenGui")
gui.Name = "CharacterSelectGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
background.BackgroundTransparency = 0.08
background.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.12)
title.Position = UDim2.fromScale(0, 0.05)
title.BackgroundTransparency = 1
title.Text = "ESCOLHA SEU TOON"
title.TextScaled = true
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 238, 210)
title.TextStrokeTransparency = 0.35
title.Parent = background

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.fromScale(1, 0.045)
subtitle.Position = UDim2.fromScale(0, 0.155)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Fuja do zoológico antes que os guardas encontrem você."
subtitle.TextScaled = true
subtitle.Font = Enum.Font.GothamBold
subtitle.TextColor3 = Color3.fromRGB(180, 170, 220)
subtitle.Parent = background

local grid = Instance.new("Frame")
grid.Size = UDim2.fromScale(0.82, 0.48)
grid.Position = UDim2.fromScale(0.09, 0.25)
grid.BackgroundTransparency = 1
grid.Parent = background

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.fromScale(0.3, 0.43)
layout.CellPadding = UDim2.fromScale(0.045, 0.08)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = grid

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.fromScale(0.55, 0.055)
selectedLabel.Position = UDim2.fromScale(0.225, 0.78)
selectedLabel.BackgroundTransparency = 1
selectedLabel.TextScaled = true
selectedLabel.Font = Enum.Font.FredokaOne
selectedLabel.TextColor3 = Color3.fromRGB(255, 238, 210)
selectedLabel.Text = "Selecionado: Momo"
selectedLabel.Parent = background

local playButton = Instance.new("TextButton")
playButton.Size = UDim2.fromScale(0.28, 0.085)
playButton.Position = UDim2.fromScale(0.36, 0.86)
playButton.BackgroundColor3 = Color3.fromRGB(255, 80, 145)
playButton.Text = "ENTRAR NO ZOO"
playButton.TextScaled = true
playButton.Font = Enum.Font.FredokaOne
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.Parent = background

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = playButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 190, 220)
stroke.Parent = playButton

local function makeCard(data)
	local card = Instance.new("TextButton")
	card.Name = data.Name .. "Card"
	card.BackgroundColor3 = Color3.fromRGB(32, 27, 50)
	card.Text = ""
	card.AutoButtonColor = false
	card.Parent = grid

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 18)
	c.Parent = card

	local s = Instance.new("UIStroke")
	s.Thickness = data.Name == selected and 4 or 2
	s.Color = data.Name == selected and data.Color or Color3.fromRGB(80, 70, 110)
	s.Parent = card

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.fromScale(1, 0.42)
	icon.Position = UDim2.fromScale(0, 0.06)
	icon.BackgroundTransparency = 1
	icon.Text = data.Emoji
	icon.TextScaled = true
	icon.Font = Enum.Font.FredokaOne
	icon.TextColor3 = data.Color
	icon.Parent = card

	local name = Instance.new("TextLabel")
	name.Size = UDim2.fromScale(1, 0.22)
	name.Position = UDim2.fromScale(0, 0.48)
	name.BackgroundTransparency = 1
	name.Text = data.Name
	name.TextScaled = true
	name.Font = Enum.Font.FredokaOne
	name.TextColor3 = Color3.fromRGB(255, 238, 210)
	name.Parent = card

	local role = Instance.new("TextLabel")
	role.Size = UDim2.fromScale(1, 0.16)
	role.Position = UDim2.fromScale(0, 0.72)
	role.BackgroundTransparency = 1
	role.Text = data.Role
	role.TextScaled = true
	role.Font = Enum.Font.GothamBold
	role.TextColor3 = data.Color
	role.Parent = card

	card.MouseEnter:Connect(function()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 37, 68) }):Play()
	end)

	card.MouseLeave:Connect(function()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(32, 27, 50) }):Play()
	end)

	card.MouseButton1Click:Connect(function()
		selected = data.Name
		selectedLabel.Text = "Selecionado: " .. data.Name .. " — " .. data.Role
		for _, child in ipairs(grid:GetChildren()) do
			local uiStroke = child:FindFirstChildOfClass("UIStroke")
			if uiStroke then
				uiStroke.Thickness = 2
				uiStroke.Color = Color3.fromRGB(80, 70, 110)
			end
		end
		s.Thickness = 4
		s.Color = data.Color
	end)
end

for _, data in ipairs(characters) do
	makeCard(data)
end

playButton.MouseButton1Click:Connect(function()
	remote:FireServer(selected)
	TweenService:Create(background, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
	task.delay(0.35, function()
		gui:Destroy()
	end)
end)
