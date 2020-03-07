local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Bus = ReplicatedStorage.Models.Bus
local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local World = Roact.Component:extend("World")

function World:init()
	self.folderRef = Roact.createRef()
end

function World:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef,
	})
end

function World:applyTripStatus()
	if self.props.tripStatus == nil then
		if self.bus ~= nil then
			self.bus:Destroy()
		end
	else
		local status = self.props.tripStatus

		if status.type == "driving" then
			if self.bus == nil then
				self.bus = Bus:Clone()
				self.bus.Parent = self.folderRef:getValue()
			end

			self.bus:SetPrimaryPartCFrame(CFrame.new(Vector3.new(500 + status.progress, 0, 500)))
		else
			error("Unknown trip status type " .. status.type)
		end
	end
end

function World:didMount()
	self:applyTripStatus()
end

function World:didUpdate()
	self:applyTripStatus()
end

return World