extends MarginContainer

func _ready():
	# Get the screen size
	var screen_size = get_viewport_rect().size

	# Calculate the position for the MarginContainer
	var x = screen_size.x / 2  # Center horizontally
	var y = screen_size.y * 0.75  # Position 75% from the top (adjust to your liking)

	# Set the MarginContainer's position
	position = Vector2(x, y)
