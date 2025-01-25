extends Node2D

@export_group("Old")
@export var speed_increase = 200
@export var turn_speed = 5.0
@export var max_velocity = 200
@export var gravity = 450.8

@export_group("Movement")
@export var speed = 150
@export var acceleration = 500
@export var rotation_speed = 20.0
@export var friction = 900
@export var min_speed = 100
@export var max_speed = 2000
@export var air_velocity = Vector2()

@export_group("Body")
@export var body_scene : PackedScene
@export var body_segments =  5
@export var scale_curve : Curve
@export var body_scale = 2.0
@export var snap_duration = 0.2
@export var follow_distance = 30

var is_in_bubble = true
var velocity = Vector2()

func _ready():
	var last_actor = self
	for i in body_segments:
		var new_body = body_scene.instantiate() as Body
		new_body.set_following(last_actor, snap_duration, follow_distance)
		var scale_ratio =  float(i) / float(body_segments)
		new_body.scale = new_body.scale * body_scale * scale_curve.sample(scale_ratio)
		last_actor = new_body
		add_sibling.call_deferred(new_body)
	
func _process(delta):
	slither_movement(delta)

func is_boosting():
	return Input.is_action_pressed("boost")
	
func slither_movement(delta):
	# Rotation
	var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
	global_rotation = rotate_toward(global_rotation, desired_rotation, delta * rotation_speed)
		
	if is_in_bubble:
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
		#global_rotation = air_velocity.normalized().angle() + 90
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

func collect_oxygen(area : Node2D):
	area.queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("bubble"):
		is_in_bubble = true
	elif area.is_in_group("oxygen"):
		collect_oxygen(area)
		

func _on_area_2d_area_exited(area):
	if area.is_in_group("bubble"):
		is_in_bubble = false
