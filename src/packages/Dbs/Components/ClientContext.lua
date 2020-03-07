local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local ClientContext = Roact.createContext(nil)

local function with(callback)
	return Roact.createElement(ClientContext.Consumer, {
		render = function(clientSession)
			if clientSession == nil then
				error("Cannot access client session from this point in the tree.")
			end

			return callback(clientSession)
		end,
	})
end

return {
	Provider = ClientContext.Provider,
	with = with,
}