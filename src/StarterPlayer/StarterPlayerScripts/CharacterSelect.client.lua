local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:WaitForChild("CharacterRemotes"):WaitForChild("SelectCharacter")

-- TEMP: seleção automática (pra testar)
task.wait(2)

local characters = {"Momo","Porinha","Leon","Elly","Snapper","Grumblet"}
local chosen = characters[math.random(1, #characters)]

print("Escolhido:", chosen)
remote:FireServer(chosen)