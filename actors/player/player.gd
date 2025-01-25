extends Node2D

@export var speed_increase = 200
@export var turn_speed = 5.0
@export var max_velocity = 200
@export var gravity = 450.8

@export var speed = 150
@export var acceleration = 500
@export var rotation_speed = 20.0
@export var friction = 900
@export var min_speed = 100
@export var max_speed = 2000
@export var air_velocity = Vector2()

var is_in_bubble = true
var velocity = Vector2()

	
func _process(delta):
	slither_movement(delta)

func is_boosting():
	return Input.is_action_pressed("boost")
	
func slither_movement(delta):
	if is_in_bubble:
		# Rotation
		var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
		global_rotation = rotate_toward(global_rotation, desired_rotation, delta * rotation_speed)
		
		# Apply Friction and Acceleration
		if is_boosting():
			speed += acceleration * delta
		else:
			speed -= friction * delta
			
		speed = clamp(speed, min_speed, max_speed)
		
		# Update Transform
		air_velocity = -global_transform.y * speed
		global_position += -global_transform.y * speed * delta
		
		$Label.text = str(speed)
	else:
		global_rotation = air_velocity.normalized().angle() + 90
		air_velocity.y += gravity * delta
		global_position += air_velocity * delta


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
