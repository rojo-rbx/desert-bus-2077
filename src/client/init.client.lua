print("Client started")

while not game:IsLoaded() do
	game.Loaded:Wait()
end

print("Client loaded")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dbs = ReplicatedStorage.Packages.Dbs

local Net = require(ReplicatedStorage.Packages.Net)
local Api = require(Dbs.Api)

local client = Net.NetClient.connect(Api, {
	tripStarted = function()
		print("trip started!!")
	end,
})

client:startTrip()