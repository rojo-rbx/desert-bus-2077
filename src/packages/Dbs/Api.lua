local Net = require(script.Parent.Parent.Net)
local t = require(script.Parent.Parent.t)

local TripStatus = t.union(
	t.strictInterface({
		type = t.literal("driving"),
		progress = t.number,
		busX = t.number,
		busSlope = t.number,
		busSlopeInput = t.number,
	}),

	t.strictInterface({
		type = t.literal("crashed"),
		progress = t.number,
		busX = t.number
	})
)

return {
	fromClient = {
		startTrip = {
			arguments = Net.args(),
		},

		steerBus = {
			arguments = Net.args(
				{"tripId", t.string},
				{"steerInput", t.number}
			)
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