local Players = game:GetService("Players")

local ServerSession = {}
ServerSession.__index = ServerSession

function ServerSession.new()
	local session = setmetatable({
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

	return session
end

function ServerSession:registerExistingPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		self:registerPlayer(player)
	end
end

function ServerSession:unregisterPlayer(player)
	self.players[player.UserId] = nil
end

function ServerSession:registerPlayer(player)
	self.players[player.UserId] = {
		busId = {},
	}
end

function ServerSession:stop()
	for _, connection in ipairs(self.globalConnections) do
		connection:Disconnect()
	end

	self.globalConnections = {}
end

return ServerSession