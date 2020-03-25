local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Bus = ReplicatedStorage.Models.Bus
local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local Desert = require(script.Parent.Desert)

local activeRoadRadius = 15

local World = Roact.Component:extend("World")

function World:init()
	self.folderRef = Roact.createRef()
	self.bus = Bus:Clone()
	self.haveSeated = false
end

function World:render()
	local children = nil

	local status = self.props.tripStatus
	if status ~= nil then
		if status.type == "driving" or status.type == "crashed" then
			children = {
				Desert = Roact.createElement(Desert, {
					progress = status.progress,
				}),
			}
		end
	end

	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef,
	}, children)
end

function World:applyTripStatus()
	local status = self.props.tripStatus

	if status ~= nil then
		if status.type == "driving" then
			local busPos = Vector3.new(
				activeRoadRadius * status.busX,
				3,
				-status.progress * 30
			)

			self.bus:SetPrimaryPartCFrame(CFrame.new(busPos))

			if not self.haveSeated and LocalPlayer.Character ~= nil then
				print("Trying to seat character...")

				local driverSeat = self.bus:FindFirstChild("DriverSeat")
				local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				hrp.CFrame = driverSeat.CFrame + Vector3.new(0, 1, 0)

				local weld = Instance.new("WeldConstraint")
				weld.Parent = hrp
				weld.Part0 = hrp
				weld.Part1 = driverSeat

				self.haveSeated = true
			end
		elseif status.type == "crashed" then
			local busPos = Vector3.new(
				activeRoadRadius * status.busX,
				2,
				-status.progress * 30
			)

			local brokenDownTilt = math.sign(status.busX) * -math.pi / 32
			local busTilt = CFrame.Angles(0, 0, brokenDownTilt)

			self.bus:SetPrimaryPartCFrame(busTilt * CFrame.new(busPos))
		else
			error("Unknown trip status type " .. status.type)
		end
	end
end

function World:didMount()
	self.bus.Parent = self.folderRef:getValue()
	self:applyTripStatus()
end

function World:didUpdate()
	self:applyTripStatus()
end

return World