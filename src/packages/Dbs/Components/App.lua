local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local ClientContext = require(script.Parent.ClientContext)
local TripInterface = require(script.Parent.TripInterface)
local World = require(script.Parent.World)
local withTripStatus = require(script.Parent.withTripStatus)

local function AppLoading()
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		Font = Enum.Font.SourceSans,
		TextSize = 30,
		Text = "Loading...",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		TextColor3 = Color3.fromRGB(240, 240, 240),
		BorderSizePixel = 0,
	})
end

local function App(props)
	if props.state == "loading" then
		return Roact.createElement(Roact.Portal, {
			target = Players.LocalPlayer.PlayerGui,
		}, {
			Ui = Roact.createElement("ScreenGui", {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ResetOnSpawn = false,
			}, {
				Roact.createElement(AppLoading),
			}),
		})
	end

	return Roact.createElement(ClientContext.Provider, {
		value = props.clientSession,
	}, {
		PlayerGui = Roact.createElement(Roact.Portal, {
			target = Players.LocalPlayer.PlayerGui,
		}, {
			Ui = Roact.createElement("ScreenGui", {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ResetOnSpawn = false,
			}, {
				StartTrip = ClientContext.with(function(clientSession)
					return Roact.createElement("TextButton", {
						Size = UDim2.new(0, 200, 0, 40),
						Position = UDim2.new(1, -8, 1, -8),
						AnchorPoint = Vector2.new(1, 1),
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

				TripStatus = Roact.createElement(TripInterface),
			}),
		}),

		Workspace = Roact.createElement(Roact.Portal, {
			target = Workspace,
		}, {
			World = withTripStatus(function(tripStatus)
				return Roact.createElement(World, {
					tripStatus = tripStatus,
				})
			end),
		}),
	})
end

return App