local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local ClientContext = require(script.Parent.ClientContext)

local BusControlsInner = Roact.Component:extend("BusControlsInner")

function BusControlsInner:init()
	self.clientSession = self.props.clientSession
end

function BusControlsInner:render()
	return nil
end

function BusControlsInner:didMount()
	self.connections = {
		RunService.Stepped:Connect(function()
			local leftDown = UserInputService:IsKeyDown(Enum.KeyCode.A)
			local rightDown = UserInputService:IsKeyDown(Enum.KeyCode.D)

			if rightDown then
				self.clientSession:setSteeringInput(1)
			elseif leftDown then
				self.clientSession:setSteeringInput(-1)
			else
				self.clientSession:setSteeringInput(0)
			end
		end)
	}
end

function BusControlsInner:willUnmount()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = {}
end

local function BusControls()
	return ClientContext.with(function(clientSession)
		return Roact.createElement(BusControlsInner, {
			clientSession = clientSession,
		})
	end)
end

return BusControls