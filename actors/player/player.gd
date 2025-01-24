extends Node2D

@export var speed = 200
@export var turn_speed = 5.0

func _process(delta):
	# Rotation
	var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
	global_rotation = rotate_toward(global_rotation, desired_rotation, delta * turn_speed)
	
	# Movement
	global_position += global_transform.y * speed * delta
