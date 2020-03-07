local t = require(script.Parent.Parent.t)

local endpoint = t.strictInterface({
	arguments = t.callback,
})

return t.strictInterface({
	fromClient = t.map(t.string, endpoint),
	fromServer = t.map(t.string, endpoint),
})