extends Node2D

@export var sprite_scene: PackedScene  # Assign your Sprite2D scene
@export var player: Node2D  # Assign your Player node
@export var spawn_distance: float = 200.0  # Distance threshold to spawn new sprites
@export var min_size: float = 0.5  # Minimum sprite scale
@export var max_size: float = 2.0  # Maximum sprite scale
@export var spawn_rate: float = 1.0  # Seconds between spawns

var last_spawn_position: Vector2  # Stores last spawn position

func _ready():
	last_spawn_position = player.position  # Initialize tracking
	spawn_sprite()  # Spawn the first sprite
	set_process(true)

func _process(delta):
	if player.position.distance_to(last_spawn_position) >= spawn_distance:
		spawn_sprite()
		last_spawn_position = player.position  # Update last spawn position

func spawn_sprite():
	if not sprite_scene:
		return
	
	var sprite_instance = sprite_scene.instantiate() as Node2D
	
	# Spawn randomly near the player
	var offset = Vector2(randf_range(-spawn_distance, spawn_distance), randf_range(-spawn_distance, spawn_distance))
	sprite_instance.position = player.position + offset

	# Random size
	var random_scale = randf_range(min_size, max_size)
	sprite_instance.scale = Vector2(random_scale, random_scale)

	add_child(sprite_instance)  # Add to the scene
