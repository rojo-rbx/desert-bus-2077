local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local withTripStatus = require(script.Parent.withTripStatus)

local function TripInterface(props)
	return withTripStatus(function(tripStatus)
		if tripStatus == nil then
			return nil
		end

		return Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 40, 0, 40),
			Position = UDim2.new(0, 80, 0, 80),
			Text = tripStatus.type .. " : " .. tripStatus.progress,
		})
	end)
end

return TripInterface