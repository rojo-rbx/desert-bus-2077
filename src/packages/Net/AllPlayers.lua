--[[
	Marker that indicates that an event should propagate to all players.
]]

local AllPlayers = newproxy(true)

getmetatable(AllPlayers, {
	__tostring = function()
		return "[All Players]"
	end,
})

return AllPlayers