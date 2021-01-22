local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local withTripStatus = require(script.Parent.withTripStatus)

local function TripInterface(props)
	return withTripStatus(function(tripStatus)
		if tripStatus == nil then
			return nil
		end

		return Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 400, 0, 57),
			Position = UDim2.new(0.5, 0, 0, 80),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			Color3 = Color3.fromRGB(240, 240, 240),
			BorderSizePixel = 0,
			TextSize = 40,
			Font = Enum.Font.SourceSans,
			Text = tripStatus.type .. " : " .. math.round(tripStatus.progress),
		})
	end)
end

return TripInterface
