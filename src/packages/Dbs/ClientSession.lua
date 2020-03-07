local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientSession = {}
ClientSession.__index = ClientSession

function ClientSession.new(netClient)
	return setmetatable({
		netClient = netClient,
		tripId = nil,
		tripStatus = nil,
		signal = Instance.new("BindableEvent"),
	}, ClientSession)
end

function ClientSession:subscribe(callback)
	return self.signal.Event:Connect(callback)
end

function ClientSession:startTrip()
	print("asking server to start a trip...")
	self.netClient:startTrip()
end

function ClientSession:tripStarted(tripId, tripStatus)
	print("server told us our trip started")

	self.tripId = tripId
	self.tripStatus = tripStatus
	self.signal:Fire(self.tripStatus)
end

function ClientSession:tripStatusUpdated(tripId, tripStatus)
	if tripId ~= self.tripId then
		warn("Server sent status update for wrong trip")
		return
	end

	self.tripStatus = tripStatus
	self.signal:Fire(self.tripStatus)
end

return ClientSession