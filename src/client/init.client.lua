print("Client started")

while not game:IsLoaded() do
	game.Loaded:Wait()
end

print("Client loaded")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dbs = ReplicatedStorage.Packages.Dbs

local Net = require(ReplicatedStorage.Packages.Net)
local Roact = require(ReplicatedStorage.Packages.Roact)

local ClientSession = require(Dbs.ClientSession)
local App = require(Dbs.Components.App)
local Api = require(Dbs.Api)

local tree = Roact.mount(
	Roact.createElement(App, {
		state = "loading",
		clientSession = nil,
	}),
	game.Players.LocalPlayer.PlayerGui
)

local clientSession

local netClient = Net.NetClient.connect(Api, {
	tripStarted = function(tripId)
		clientSession:tripStarted(tripId)
	end,

	tripStatusUpdated = function(tripId, status)
		clientSession:tripStatusUpdated(tripId, status)
	end,
})

clientSession = ClientSession.new(netClient)

Roact.update(
	tree,
	Roact.createElement(App, {
		state = "loaded",
		clientSession = clientSession,
	})
)
