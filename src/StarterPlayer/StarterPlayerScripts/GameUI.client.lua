local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("GameRemotes")
local objectiveUpdated = remotes:WaitForChild("ObjectiveUpdated")
local gameFinished = remotes:WaitForChild("GameFinished")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(0.3, 0.05)
label.Position = UDim2.fromScale(0.35, 0.02)
label.BackgroundTransparency = 0.4
label.TextScaled = true
label.Font = Enum.Font.FredokaOne
label.TextColor3 = Color3.new(1,1,1)
label.Parent = gui

objectiveUpdated.OnClientEvent:Connect(function(done, total)
	label.Text = "Objetivos: " .. done .. "/" .. total
end)

gameFinished.OnClientEvent:Connect(function(result, text)
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 230, 120)
	label.Size = UDim2.fromScale(0.6, 0.1)
end)