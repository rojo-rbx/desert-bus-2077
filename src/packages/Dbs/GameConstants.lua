local RunService = game:GetService("RunService")

return {
	TripDistance = RunService:IsStudio() and 3 or 8 * 60 * 60,
}