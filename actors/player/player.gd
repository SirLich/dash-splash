extends Node2D

@export var speed_increase = 200
@export var turn_speed = 5.0
@export var max_velocity = 200
@export var gravity = 9.8

@export var base_speed = 20
@export var acceleration = 20

var is_in_bubble = true
var velocity = Vector2()

func _process(delta):
	slither_movement(delta)
	
func slither_movement(delta):
	pass
	
func velocity_movement(delta):
	if is_in_bubble:
		# Rotation
		var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
		global_rotation = rotate_toward(global_rotation, desired_rotation, delta * turn_speed)
		
		# Movement
		velocity += -global_transform.y * speed_increase * delta
		velocity = velocity.clampf(-max_velocity, max_velocity)
	else:
		# Just gravity
		velocity.y += gravity * delta
	
	# Move based on velocity
	global_position += velocity * delta
	
	
	$Label.text = str(velocity)	


func _on_area_2d_area_entered(area):
	is_in_bubble = true

func _on_area_2d_area_exited(area):
	is_in_bubble = false
