print("Server started")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Dbs = ReplicatedStorage.Packages.Dbs
local Models = ReplicatedStorage.Models

local lobby = Models.Lobby:Clone()
lobby:SetPrimaryPartCFrame(CFrame.new(Vector3.new(500, 0, 500)))
lobby.Parent = Workspace

local Net = require(ReplicatedStorage.Packages.Net)
local Api = require(Dbs.Api)

local ServerSession = require(script.ServerSession)

local serverSession

local netClient
netClient = Net.NetServer.create(Api, {
	startTrip = function(player)
		serverSession:startTrip(player)
	end,
})

serverSession = ServerSession.new(netClient)