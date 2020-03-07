local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AllPlayers = require(script.Parent.AllPlayers)
local validateApiSpec = require(script.Parent.validateApiSpec)

local NetServer = {}

function NetServer:__index(key)
	error(("%q is not a valid member of NetServer"):format(tostring(key)), 2)
end

function NetServer.create(apiSpec, handlers)
	assert(validateApiSpec(apiSpec))
	assert(typeof(handlers) == "table")

	local self = {}

	setmetatable(self, NetServer)

	local remotes = Instance.new("Folder")
	remotes.Name = "Events"

	for name, endpoint in pairs(apiSpec.fromClient) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = "fromClient-" .. name
		remote.Parent = remotes

		local handler = handlers[name]

		if handler == nil then
			error(("Need to implement server handler for %q"):format(name), 2)
		end

		remote.OnServerEvent:Connect(function(player, ...)
			assert(typeof(player) == "Instance" and player:IsA("Player"))
			assert(endpoint.arguments(...))

			handler(player, ...)
		end)
	end

	for name, endpoint in pairs(apiSpec.fromServer) do
		local remote = Instance.new("RemoteEvent")
		remote.Name = "fromServer-" .. name
		remote.Parent = remotes

		self[name] = function(_, player, ...)
			if player == AllPlayers then
				assert(endpoint.arguments(...))

				remote:FireAllClients(...)
			else
				assert(typeof(player) == "Instance" and player:IsA("Player"), "Missing player argument")
				assert(endpoint.arguments(...))

				remote:FireClient(player, ...)
			end
		end
	end

	remotes.Parent = ReplicatedStorage

	return self
end

return NetServer