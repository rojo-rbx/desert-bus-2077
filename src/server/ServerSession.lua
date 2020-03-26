local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages

local GameConstants = require(Packages.Dbs.GameConstants)

local function createTrip(driverPlayer)
	local tripId = HttpService:GenerateGUID(false)

	local trip = {
		players = {driverPlayer.UserId},
		status = {
			type = "driving",
			progress = 0,
			busX = 0,
			busSlope = 0,
			busSlopeInput = 0.05,
		},
	}

	return tripId, trip
end

local ServerSession = {}
ServerSession.__index = ServerSession

function ServerSession.new(netClient)
	local session = setmetatable({
		netClient = netClient,
		trips = {},
		players = {},
		globalConnections = {},
	}, ServerSession)

	session:registerExistingPlayers()

	local addedConnection = Players.PlayerAdded:Connect(function(player)
		session:registerPlayer(player)
	end)
	table.insert(session.globalConnections, addedConnection)

	local removedConnection = Players.PlayerRemoving:Connect(function(player)
		session:unregisterPlayer(player)
	end)
	table.insert(session.globalConnections, removedConnection)

	local stepConnection = RunService.Heartbeat:Connect(function(dt)
		session:step(dt)
	end)
	table.insert(session.globalConnections, stepConnection)

	return session
end

function ServerSession:step(dt)
	for tripId, trip in pairs(self.trips) do
		if trip.status.type == "driving" then
			trip.status.progress = trip.status.progress + dt

			trip.status.busSlope = trip.status.busSlope + trip.status.busSlopeInput * dt
			trip.status.busX = trip.status.busX + trip.status.busSlope * dt

			if math.abs(trip.status.busX) > 1 then
				-- you crashed and ruined everything.

				trip.status = {
					type = "crashed",
					progress = trip.status.progress,
					busX = trip.status.busX,
				}
			end

			if trip.status.progress >= GameConstants.TripDistance then
				-- you won
				-- TODO: award something?

				self.trips[tripId] = nil

				for _, playerId in ipairs(trip.players) do
					local playerData = self.players[playerId]

					if playerData ~= nil then
						playerData.tripId = nil
						self.netClient:tripCompleted(playerData.player, tripId)
					end
				end
			else
				for _, playerId in ipairs(trip.players) do
					local playerData = self.players[playerId]

					if playerData ~= nil then
						self.netClient:tripStatusUpdated(playerData.player, tripId, trip.status)
					end
				end
			end
		end
	end
end

function ServerSession:canStartTrip(player)
	local playerData = self.players[player.UserId]

	return playerData.tripId == nil
end

function ServerSession:startTrip(player)
	local playerData = self.players[player.UserId]

	if playerData == nil then
		warn("Cannot start a trip from unknown player " .. player.Name)
		return
	end

	if self:canStartTrip(player) then
		local tripId, trip = createTrip(player)

		self.trips[tripId] = trip
		playerData.tripId = tripId

		self.netClient:tripStarted(player, tripId, trip.status)
	end
end

function ServerSession:steerBus(player, tripId, steerInput)
	local playerData = self.players[player.UserId]
	if playerData == nil then
		warn("Cannot steer bus from an unknown player")
		return
	end

	local trip = self.trips[tripId]
	if trip == nil then
		warn("Cannot steer an unknown trip")
		return
	end

	if playerData.tripId ~= tripId then
		warn("Cannot steer someone else's bus")
		return
	end

	if trip.status.type ~= "driving" then
		warn("Cannot steer a bus that isn't driving")
	end

	steerInput = math.clamp(steerInput, -1, 1)
	trip.status.busSlopeInput = steerInput + 0.05
end

function ServerSession:registerExistingPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		self:registerPlayer(player)
	end
end

function ServerSession:unregisterPlayer(player)
	-- TODO: Save player data

	self.players[player.UserId] = nil
end

function ServerSession:registerPlayer(player)
	-- TODO: Load saved player data

	self.players[player.UserId] = {
		player = player,
		tripId = nil,
	}
end

function ServerSession:stop()
	for _, connection in ipairs(self.globalConnections) do
		connection:Disconnect()
	end

	self.globalConnections = {}
end

return ServerSession