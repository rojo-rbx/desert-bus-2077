print("Server started")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Models = ReplicatedStorage.Models

local lobby = Models.Lobby:Clone()
lobby:SetPrimaryPartCFrame(CFrame.new(Vector3.new(500, 0, 500)))
lobby.Parent = Workspace