extends Node2D

@export_group("Movement")
@export var velocity = Vector2()

@export var gravity = 450.8
@export var acceleration = 500
@export var rotation_speed = 20.0
@export var friction = 3

@export var min_speed = 0
@export var max_speed = 1000

@export_group("Body")
@export var body_scene : PackedScene
@export var body_segments =  5
@export var scale_curve : Curve
@export var body_scale = 2.0
@export var snap_duration = 0.2
@export var follow_distance = 30

var is_in_bubble = true
var last_rotation = 90
var last_delta = 1.0
var wiggles_per_second = 0.0
var max_wiggles = 50
var wiggle_reduce_factor = 4
var wiggle_acceleration = 100
var wiggle_size = 0.5

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
	var rotation_delta = global_rotation - last_rotation

	if (abs(rotation_delta) > wiggle_size):
		wiggles_per_second += 1
		last_rotation = global_rotation
		last_delta = rotation_delta
	
	wiggles_per_second -= wiggle_reduce_factor * delta
	wiggles_per_second = clamp(wiggles_per_second, 0 , max_wiggles)
	
	# Rotation
	var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
	global_rotation = rotate_toward(global_rotation, desired_rotation, delta * rotation_speed)
		
	if is_in_bubble:
		# Apply Friction and Acceleration
		if is_boosting():
			velocity += -global_transform.y * acceleration * delta
		else:
			if velocity.length() > 0.01:
				velocity = velocity * (1.0 - friction * delta)
			else:
				velocity = Vector2.ZERO
		
		var speed = velocity.length()
		speed = clamp(speed, min_speed, max_speed)
		velocity = velocity.normalized() * speed
		
		# Update Transform
		velocity -= global_transform.y * speed * delta
		global_position += velocity * delta
		
	else:
		#global_rotation = velocity.normalized().angle() + 90
		
		var wiggle_factor = float(wiggles_per_second) / float(max_wiggles)
		velocity += -global_transform.y * wiggle_acceleration * wiggle_factor * delta

		velocity.y += gravity * delta
		global_position += velocity * delta
		
		$Label.text = str(wiggle_factor)


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
