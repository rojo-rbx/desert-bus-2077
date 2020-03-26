local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local ClientContext = require(script.Parent.ClientContext)

local Connector = Roact.Component:extend("Connector")

function Connector:init()
	self:setState({
		tripStatus = self.props.clientSession.tripStatus,
	})
end

function Connector:render()
	return self.props.render(self.state.tripStatus)
end

function Connector:didMount()
	self.connection = self.props.clientSession:subscribe(function(tripStatus)
		self:setState({
			tripStatus = tripStatus or Roact.None,
		})
	end)
end

function Connector:willUnmount()
	self.connection:Disconnect()
	self.connection = nil
end

local function withTripStatus(callback)
	return ClientContext.with(function(clientSession)
		return Roact.createElement(Connector, {
			render = callback,
			clientSession = clientSession,
		})
	end)
end

return withTripStatus