local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CharacterConfig = require(ReplicatedStorage.Shared.CharacterConfig)

local SelectCharacter = ReplicatedStorage
	:WaitForChild("CharacterRemotes")
	:WaitForChild("SelectCharacter")

local characters = {
	"Leon",
	"Elly",
	"Porinha",
	"Momo",
	"Snapper",
	"Grumblet",
}

local characterDescriptions = {
	Leon = "Forte e corajoso. Ideal para distrair guardas e abrir caminho.",
	Elly = "Pesada e poderosa. Perfeita para quebrar obstáculos.",
	Porinha = "Pequena e ágil. Boa para suporte e sobrevivência.",
	Momo = "Rápido e esperto. Excelente para escalar e explorar.",
	Snapper = "Resistente e sorrateiro. Ótimo perto da água.",
	Grumblet = "Barulhento e reclamão. Especialista em causar confusão.",
}

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function createStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = transparency or 0
	stroke.Parent = parent
	return stroke
end

local function createLabel(parent, text, size, color, font)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextSize = size
	label.Font = font or Enum.Font.GothamBold
	label.TextWrapped = true
	label.Parent = parent
	return label
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharacterSelectionGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(8, 13, 18)
overlay.BackgroundTransparency = 0.08
overlay.Parent = screenGui

local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.fromScale(0.5, 0.5)
container.Size = UDim2.fromScale(0.82, 0.78)
container.BackgroundColor3 = Color3.fromRGB(18, 27, 34)
container.Parent = overlay
createCorner(container, 24)
createStroke(container, Color3.fromRGB(87, 125, 106), 2, 0.15)

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 28)
padding.PaddingBottom = UDim.new(0, 28)
padding.PaddingLeft = UDim.new(0, 32)
padding.PaddingRight = UDim.new(0, 32)
padding.Parent = container

local title = createLabel(container, "ESCOLHA SEU ANIMAL", 34, Color3.fromRGB(241, 246, 239), Enum.Font.GothamBlack)
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.fromOffset(0, 0)

local subtitle = createLabel(container, "Cada personagem tem habilidades próprias para escapar do zoológico.", 18, Color3.fromRGB(190, 205, 195), Enum.Font.Gotham)
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 34)
subtitle.Position = UDim2.fromOffset(0, 48)

local grid = Instance.new("Frame")
grid.Name = "CharacterGrid"
grid.BackgroundTransparency = 1
grid.Position = UDim2.fromOffset(0, 100)
grid.Size = UDim2.new(1, 0, 1, -100)
grid.Parent = container

local layout = Instance.new("UIGridLayout")
layout.CellPadding = UDim2.fromOffset(18, 18)
layout.CellSize = UDim2.new(0.31, 0, 0.46, 0)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = grid

local function selectCharacter(characterName)
	SelectCharacter:FireServer(characterName)
	screenGui.Enabled = false
end

local function createCharacterCard(characterName, order)
	local config = CharacterConfig[characterName]
	local abilities = config and config.Abilities or {}

	local card = Instance.new("TextButton")
	card.Name = characterName .. "Card"
	card.LayoutOrder = order
	card.AutoButtonColor = true
	card.Text = ""
	card.BackgroundColor3 = Color3.fromRGB(29, 43, 52)
	card.Parent = grid
	createCorner(card, 18)
	createStroke(card, Color3.fromRGB(116, 154, 128), 1.5, 0.35)

	local cardPadding = Instance.new("UIPadding")
	cardPadding.PaddingTop = UDim.new(0, 16)
	cardPadding.PaddingBottom = UDim.new(0, 16)
	cardPadding.PaddingLeft = UDim.new(0, 16)
	cardPadding.PaddingRight = UDim.new(0, 16)
	cardPadding.Parent = card

	local nameLabel = createLabel(card, characterName, 26, Color3.fromRGB(255, 244, 203), Enum.Font.GothamBlack)
	nameLabel.Name = "CharacterName"
	nameLabel.Size = UDim2.new(1, 0, 0, 34)
	nameLabel.Position = UDim2.fromOffset(0, 0)

	local description = createLabel(card, characterDescriptions[characterName] or "Personagem jogável.", 15, Color3.fromRGB(215, 225, 218), Enum.Font.Gotham)
	description.Name = "Description"
	description.Size = UDim2.new(1, 0, 0, 58)
	description.Position = UDim2.fromOffset(0, 44)

	local abilityText = "Habilidades: " .. table.concat(abilities, " / ")
	local abilitiesLabel = createLabel(card, abilityText, 14, Color3.fromRGB(151, 214, 173), Enum.Font.GothamBold)
	abilitiesLabel.Name = "Abilities"
	abilitiesLabel.Size = UDim2.new(1, 0, 0, 48)
	abilitiesLabel.Position = UDim2.fromOffset(0, 112)

	local buttonHint = createLabel(card, "Selecionar", 16, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold)
	buttonHint.Name = "ButtonHint"
	buttonHint.AnchorPoint = Vector2.new(0.5, 1)
	buttonHint.Position = UDim2.new(0.5, 0, 1, 0)
	buttonHint.Size = UDim2.new(1, 0, 0, 28)

	card.MouseButton1Click:Connect(function()
		selectCharacter(characterName)
	end)
end

for index, characterName in ipairs(characters) do
	createCharacterCard(characterName, index)
end
