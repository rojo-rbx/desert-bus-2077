local Net = require(script.Parent.Parent.Net)

return {
	fromClient = {
		startTrip = {
			arguments = Net.args(),
		},
	},
	fromServer = {
		tripStarted = {
			arguments = Net.args()
		},
	},
}