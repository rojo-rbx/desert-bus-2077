local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local function createTrip(driverPlayer)
	local tripId = HttpService:GenerateGUID(false)

	local trip = {
		players = {driverPlayer.UserId},
		status = {
			type = "driving",
			progress = 0,
			busX = 0,
			busSlope = 0.01,
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
			trip.status.busX = trip.status.busX + trip.status.busSlope * dt

			if math.abs(trip.status.busX) > 1 then
				-- you crashed and ruined everything.

				trip.status = {
					type = "crashed",
					progress = trip.status.progress,
					busX = trip.status.busX,
				}
			end

			for _, playerId in ipairs(trip.players) do
				local playerData = self.players[playerId]

				if playerData ~= nil then
					self.netClient:tripStatusUpdated(playerData.player, tripId, trip.status)
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