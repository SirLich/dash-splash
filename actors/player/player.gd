extends Node2D

@export_group("Movement")
@export var velocity = Vector2()

@export var gravity = 1450.8
@export var acceleration = 200
@export var rotation_speed = 10.0
@export var air_rotation_speed = 30.0
@export var friction = 5

@export var min_speed = 0
@export var max_speed = 650

@export var in_water_control = 100
@export var exit_water_boost = 3.5
@export var bubble_move_delay = 0.27

@export var max_mouse_acceleration = 2000
@export var max_mouse_distance = 1000

@export_group("Body")
@export var body_scene : PackedScene
@export var body_segments =  5
@export var scale_curve : Curve
@export var body_scale = 2.0
@export var snap_duration = 0.2
@export var follow_distance = 30

var can_water_boost = false
var water_boost_delay = 0.24

var is_in_bubble = true
var can_boost = false
var last_rotation = 90
var last_delta = 1.0
var wiggles_per_second = 0.0
var max_wiggles = 10
var wiggle_reduce_factor = 6
var wiggle_acceleration = 900
var wiggle_size = 0.5
var turn_speed = 3.0
var air_turn_speed = 40

func get_turn_speed():
	if is_in_bubble:
		return rotation_speed
	return air_rotation_speed
	
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
	return Input.is_action_pressed("boost") and can_boost
	
func slither_movement(delta):
	# Rotation
	var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
	global_rotation = rotate_toward(global_rotation, desired_rotation, delta * get_turn_speed())
		
	if is_in_bubble:
		# Apply Friction and Acceleration
		
		if is_boosting():
			# Step 1: Get the desired direction (based on the look direction)
			var desired_direction = -global_transform.y.normalized()

			# Step 2: Add acceleration towards the desired direction, but do not rotate yet
			velocity += desired_direction * acceleration * delta

			# Step 3: Rotate the velocity towards the desired direction without changing its magnitude
			if velocity.length() > 0:  # Only rotate if the velocity is not zero
				var velocity_normalized = velocity.normalized()  # Preserve direction
				var desired_velocity = velocity_normalized.rotated(velocity.angle_to(desired_direction)) * velocity.length()
				velocity = lerp(velocity, desired_velocity, in_water_control * delta)
			
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
		
		# Wiggling
		var rotation_delta = global_rotation - last_rotation
		if (abs(rotation_delta) > wiggle_size):
			wiggles_per_second += 1
			last_rotation = global_rotation
			last_delta = rotation_delta
		
		wiggles_per_second -= wiggle_reduce_factor * delta
		wiggles_per_second = clamp(wiggles_per_second, 0 , max_wiggles)
	
		var wiggle_factor = float(wiggles_per_second) / float(max_wiggles)
		velocity += -global_transform.y * wiggle_acceleration * wiggle_factor * delta

		velocity.y += gravity * delta
		global_position += velocity * delta
		


func collect_oxygen(area : Node2D):
	area.queue_free()

		
func _on_area_2d_area_entered(area):
	if area.is_in_group("bubble"):
		is_in_bubble = true
		can_boost = false
		await get_tree().create_timer(bubble_move_delay).timeout
		can_boost = true
	elif area.is_in_group("oxygen"):
		collect_oxygen(area)
		

func _on_area_2d_area_exited(area):
	if area.is_in_group("bubble"):
		wiggles_per_second = 0
		is_in_bubble = false
		var boost_ratio = self.global_position.distance_to(get_global_mouse_position()) / max_mouse_distance
		print(boost_ratio)
		velocity = velocity * exit_water_boost * boost_ratio
