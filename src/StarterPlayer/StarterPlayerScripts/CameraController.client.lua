local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- deixa o Roblox controlar rotação (mouse)
camera.CameraType = Enum.CameraType.Custom

local function setupCamera(char)
	local humanoid = char:WaitForChild("Humanoid")

	-- câmera segue o personagem
	camera.CameraSubject = humanoid

	-- distância da câmera
	player.CameraMinZoomDistance = 8
	player.CameraMaxZoomDistance = 12
end

if player.Character then
	setupCamera(player.Character)
end

player.CharacterAdded:Connect(setupCamera)