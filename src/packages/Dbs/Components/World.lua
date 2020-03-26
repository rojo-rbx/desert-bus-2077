local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Bus = ReplicatedStorage.Models.Bus
local Packages = script.Parent.Parent.Parent

local Roact = require(Packages.Roact)

local Desert = require(script.Parent.Desert)
local BusControls = require(script.Parent.BusControls)

local activeRoadRadius = 20

local World = Roact.Component:extend("World")

function World:init()
	self.folderRef = Roact.createRef()
	self.bus = Bus:Clone()
	self.seatWeld = Instance.new("WeldConstraint")
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

				BusControls = Roact.createElement(BusControls),
			}
		end
	end

	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef,
	}, children)
end

function World:applyTripStatus()
	local status = self.props.tripStatus

	if status == nil then
		self.bus.Parent = nil
	else
		self.bus.Parent = self.folderRef:getValue()

		if status.type == "driving" then
			local busPos = Vector3.new(
				activeRoadRadius * status.busX,
				3,
				-status.progress * 30
			)

			local busTilt = CFrame.Angles(0, status.busSlope * -math.pi / 16, 0)

			self.bus:SetPrimaryPartCFrame(CFrame.new(busPos) * busTilt)

			if LocalPlayer.Character ~= nil then
				local driverSeat = self.bus:FindFirstChild("DriverSeat")
				local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if hrp ~= nil and hrp ~= self.seatWeld.Part1 then
					hrp.CFrame = driverSeat.CFrame + Vector3.new(0, 1, 0)

					self.seatWeld.Parent = driverSeat
					self.seatWeld.Part0 = driverSeat
					self.seatWeld.Part1 = hrp
				end
			end
		elseif status.type == "crashed" then
			local busPos = Vector3.new(
				activeRoadRadius * status.busX,
				1,
				-status.progress * 30
			)

			local brokenDownTilt = math.sign(status.busX) * -math.pi / 16
			local busTilt = CFrame.Angles(0, 0, brokenDownTilt)

			self.bus:SetPrimaryPartCFrame(CFrame.new(busPos) * busTilt)
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