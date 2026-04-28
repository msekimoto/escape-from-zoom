local ReplicatedStorage = game:GetService("ReplicatedStorage")

local folder = Instance.new("Folder")
folder.Name = "CharacterRemotes"
folder.Parent = ReplicatedStorage

local select = Instance.new("RemoteEvent")
select.Name = "SelectCharacter"
select.Parent = folder

return folder
