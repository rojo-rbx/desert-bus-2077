--[[
	This object's job is to read the common ApiSpec, which defines the protocol
	for communicating with the server and the types that each method accepts.

	On connecting to the server via `connect`, we generate an object that has
	a method for each RemoteEvent that attached validation on both ends.

	I've found that this is a super nice way to think about network
	communication in Roblox, since it lines up with other strongly-typed RPC
	systems.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local validateApiSpec = require(script.Parent.validateApiSpec)

local NetClient = {}

function NetClient:__index(key)
	error(("%q is not a valid member of NetClient"):format(tostring(key)), 2)
end

function NetClient.connect(apiSpec, handlers)
	assert(validateApiSpec(apiSpec))
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, NetClient)

	local remotes = ReplicatedStorage:WaitForChild("Events")

	for name, endpoint in pairs(apiSpec.fromClient) do
		local remote = remotes:WaitForChild("fromClient-" .. name)

		self[name] = function(_, ...)
			assert(endpoint.arguments(...))

			remote:FireServer(...)
		end
	end

	for name, endpoint in pairs(apiSpec.fromServer) do
		local remote = remotes:WaitForChild("fromServer-" .. name)

		local handler = handlers[name]

		if handler == nil then
			error(("Need to implement client handler for %q"):format(name), 2)
		end

		remote.OnClientEvent:Connect(function(...)
			assert(endpoint.arguments(...))

			handler(...)
		end)
	end

	return self
end

return NetClient