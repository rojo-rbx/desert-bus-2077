local Net = require(script.Parent.Parent.Net)
local t = require(script.Parent.Parent.t)

local TripStatus = t.strictInterface({
	type = t.literal("driving"),
	progress = t.number,
})

return {
	fromClient = {
		startTrip = {
			arguments = Net.args(),
		},
	},
	fromServer = {
		tripStarted = {
			arguments = Net.args(
				{"tripId", t.string},
				{"tripStatus", TripStatus}
			)
		},

		tripStatusUpdated = {
			arguments = Net.args(
				{"tripId", t.string},
				{"tripStatus", TripStatus}
			)
		},
	},
}