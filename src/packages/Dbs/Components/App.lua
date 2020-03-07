local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local ClientContext = require(script.Parent.ClientContext)

local function App(props)
	local children

	if props.state == "loading" then
		children = {
			LoadingLabel = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 40),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Font = Enum.Font.SourceSans,
				TextSize = 30,
				Text = "Loading...",
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				TextColor3 = Color3.fromRGB(240, 240, 240),
				BorderSizePixel = 0,
			}),
		}
	elseif props.state == "loaded" then
		children = {
			LoadedLabel = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 40),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Font = Enum.Font.SourceSans,
				TextSize = 30,
				Text = "Loaded!",
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				TextColor3 = Color3.fromRGB(240, 240, 240),
				BorderSizePixel = 0,
			}),

			StartTrip = ClientContext.with(function(clientSession)
				return Roact.createElement("TextButton", {
					Size = UDim2.new(0, 200, 0, 40),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Font = Enum.Font.SourceSans,
					TextSize = 30,
					Text = "Start Trip",
					BackgroundColor3 = Color3.fromRGB(20, 20, 20),
					TextColor3 = Color3.fromRGB(240, 240, 240),
					BorderSizePixel = 0,

					[Roact.Event.Activated] = function()
						clientSession:startTrip()
					end,
				})
			end),
		}
	end

	return Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		Roact.createElement(ClientContext.Provider, {
			value = props.clientSession,
		}, children),
	})
end

return App