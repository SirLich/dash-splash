extends Node2D

@export var sprite_scene: PackedScene 
@export var player: Node2D 
@export var screen_width: int = 1920 
@export var screen_height: int = 1080 
@export var spawn_distance_x: float = 400.0  
@export var spawn_min_distance_y: float = 250.0  
@export var spawn_max_distance_y: float = 850.0  
@export var min_size: float = 0.5 
@export var max_size: float = 3  
@export var max_bubbles: int = 12  
@export var spawn_attempts: int = 10  

var bubbles: Array = []  # Store active bubbles

func _ready():
	check_and_spawn_bubbles()

func _process(delta):
	check_and_spawn_bubbles()  

func check_and_spawn_bubbles():
	var visible_bubbles = get_visible_bubbles()
	
	if visible_bubbles.size() < max_bubbles:
		var needed_bubbles = max_bubbles - visible_bubbles.size()
		for i in range(needed_bubbles):
			spawn_bubble()

func get_visible_bubbles() -> Array:
	var visible = []
	var screen_rect = Rect2(player.position.x - screen_width / 2, 
							player.position.y - screen_height / 2, 
							screen_width, 
							screen_height)

	for bubble_data in bubbles:
		var bubble = bubble_data["node"]
		if screen_rect.has_point(bubble.position):
			visible.append(bubble)

	return visible

func spawn_bubble():
	if not sprite_scene:
		return

	var spawn_position: Vector2
	var random_scale: float
	var valid_position = false

	for i in range(spawn_attempts):
		var offset_x = randf_range(-spawn_distance_x, spawn_distance_x)
		var offset_y = -randf_range(spawn_min_distance_y, spawn_max_distance_y)  # Always above
		spawn_position = player.position + Vector2(offset_x, offset_y)
		random_scale = randf_range(min_size, max_size)

		if is_position_valid(spawn_position, random_scale):
			valid_position = true
			break  

	if not valid_position:
		return  

	var sprite_instance = sprite_scene.instantiate() as Node2D
	sprite_instance.position = spawn_position
	sprite_instance.scale = Vector2(random_scale, random_scale)

	add_child(sprite_instance)
	bubbles.append({"node": sprite_instance, "scale": random_scale, "position": spawn_position})

	sprite_instance.tree_exited.connect(func(): remove_bubble(sprite_instance))

func is_position_valid(pos: Vector2, scale: float) -> bool:
	var new_size = get_scaled_bubble_size(scale)

	for bubble_data in bubbles:
		var bubble = bubble_data["node"]
		var bubble_scale = bubble_data["scale"]
		var existing_size = get_scaled_bubble_size(bubble_scale)

		# Overlapping, not a valid position
		if bubble and bubble.position.distance_to(pos) < (new_size + existing_size):
			return false  

	# Valid position
	return true  

func get_scaled_bubble_size(scale: float) -> float:
	var base_size = 800 # bubble size, change depending on sprite size
	return (base_size * scale) / 2  # radius

func remove_bubble(sprite_instance):
	for bubble_data in bubbles:
		if bubble_data["node"] == sprite_instance:
			bubbles.erase(bubble_data)
			break
