extends MarginContainer

func _ready():
	update_position()
	
func _process(_delta):
	update_position()

func update_position():
	var screen_size = get_viewport_rect().size
	
	# Center horizontally
	position.x = (screen_size.x - size.x) / 2
	
	# 300px above the bottom
	position.y = screen_size.y - 300
