print("Client started")

while not game:IsLoaded() do
	game.Loaded:Wait()
end

print("Client loaded")