local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local SelectCharacter = ReplicatedStorage:WaitForChild("CharacterRemotes"):WaitForChild("SelectCharacter")

local characters = { "Momo", "Porinha", "Leon", "Elly", "Snapper", "Grumblet" }

local gui = Instance.new("ScreenGui")
gui.Name = "CharacterSelectionGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
frame.BackgroundTransparency = 0.08
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.12)
title.Position = UDim2.fromScale(0, 0.06)
title.BackgroundTransparency = 1
title.Text = "ESCOLHA SEU ANIMAL"
title.TextScaled = true
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 238, 210)
title.Parent = frame

local grid = Instance.new("Frame")
grid.Size = UDim2.fromScale(0.78, 0.5)
grid.Position = UDim2.fromScale(0.11, 0.25)
grid.BackgroundTransparency = 1
grid.Parent = frame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.fromScale(0.3, 0.42)
layout.CellPadding = UDim2.fromScale(0.04, 0.08)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = grid

for _, characterName in ipairs(characters) do
	local button = Instance.new("TextButton")
	button.Name = characterName .. "Button"
	button.Text = characterName
	button.TextScaled = true
	button.Font = Enum.Font.FredokaOne
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = characterName == "Porinha" and Color3.fromRGB(255, 120, 180) or Color3.fromRGB(38, 32, 58)
	button.Parent = grid

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		print("Selecionando personagem:", characterName)
		SelectCharacter:FireServer(characterName)
		gui:Destroy()
	end)
end
