--[[
	Controls rendering of the vast open sands of the desert.
]]

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoadSegment = ReplicatedStorage.Models.RoadSegment
local Packages = script.Parent.Parent.Parent

local segmentLength = RoadSegment.PrimaryPart.Size.Z
local chunkBuffer = 8

local Roact = require(Packages.Roact)

local RoadChunk = Roact.Component:extend("RoadChunk")

function RoadChunk:init()
	self.folderRef = Roact.createRef()
	self.chunk = RoadSegment:Clone()
	self.lastPos = nil
end

function RoadChunk:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef
	})
end

function RoadChunk:updatePos()
	local basePos = Vector3.new(-10, 0, 0)
	local chunkPos = basePos + Vector3.new(0, 0, -self.props.index * segmentLength)

	if chunkPos ~= self.lastPos then
		self.lastPos = chunkPos
		self.chunk:SetPrimaryPartCFrame(CFrame.new(chunkPos))
	end
end

function RoadChunk:didMount()
	self.chunk.Parent = self.folderRef:getValue()
	self:updatePos()
end

function RoadChunk:didUpdate()
	self:updatePos()
end

function RoadChunk:willUnmount()
	self.chunk:Destroy()
end

local Desert = Roact.Component:extend("Desert")

function Desert:init()
	self.folderRef = Roact.createRef()
end

function Desert:render()
	local zPos = self.props.progress * 30
	local chunkNumber = math.floor(zPos / segmentLength)

	local children = {}
	for i = chunkNumber - chunkBuffer, chunkNumber + chunkBuffer do
		children["Road " .. i] = Roact.createElement(RoadChunk, {
			index = i,
		})
	end

	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef
	}, children)
end

return Desert