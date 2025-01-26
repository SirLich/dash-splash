extends Node2D
class_name Player

@export_group("Graphics")
@export var particle_bubble : PackedScene

@export_group("Movement")
@export var velocity = Vector2()

@export var splash_packed : PackedScene

@export var gravity = 1450.8
@export var acceleration = 200
@export var rotation_speed = 10.0
@export var air_rotation_speed = 30.0
@export var friction = 5

@export var min_speed = 0
@export var max_speed = 750

@export var in_water_control = 100
@export var exit_water_boost = 2
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
@export var required_exit_velocity = max_speed - 100

signal on_eaten
var eaten = 0

var can_water_boost = false
var water_boost_delay = 0.24

var is_in_bubble = true
var can_boost = false
var last_rotation = 90
var last_delta = 1.0
var wiggles_per_second = 0.0
var max_wiggles = 5
var wiggle_reduce_factor = 6
var wiggle_acceleration = 1900
var wiggle_size = 0.2
var turn_speed = 3.0
var air_turn_speed = 40

func get_turn_speed():
	if is_in_bubble:
		return rotation_speed
	return air_rotation_speed
	
func _ready():
	modulate = Bus._color
	var last_actor = self
	for i in body_segments:
		var new_body = body_scene.instantiate() as Body
		new_body.set_following(last_actor, snap_duration, follow_distance)
		new_body.head = self
		var scale_ratio =  float(i) / float(body_segments)
		new_body.scale = new_body.scale * body_scale * scale_curve.sample(scale_ratio)
		last_actor = new_body
		add_sibling.call_deferred(new_body)
	
func _process(delta):
	var current_speed = velocity.length()
	var speed_ratio = current_speed / max_speed
	
	speed_ratio = clamp(speed_ratio, 0.0, 1.0)
	var max_rotation = 50
	$Fins/LgHeadUpperFin.rotation_degrees = speed_ratio * max_rotation
	$Fins/LgHeadLowerFin.rotation_degrees = speed_ratio * max_rotation
	$Fins/LgHeadUpperFin2.rotation_degrees = speed_ratio * -max_rotation
	$Fins/LgHeadLowerFin2.rotation_degrees = speed_ratio * -max_rotation
	slither_movement(delta)

func is_boosting():
	return Input.is_action_pressed("boost") and can_boost

	
func slither_movement(delta):
	# Rotation
	#var desired_rotation = global_position.angle_to_point(get_global_mouse_position()) + PI/2.0
	
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector.length() > 0.1:
		var desired_rotation = input_vector.angle() + PI/2
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

		velocity.y += gravity * delta
		global_position += velocity * delta
		


func collect_oxygen(area : Node2D):
	area.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("bubble"):
		is_in_bubble = true
		$JumpIn.play()
		can_boost = false
		await get_tree().create_timer(bubble_move_delay).timeout
		can_boost = true
		var new_particle = particle_bubble.instantiate()
		area.add_child(new_particle)
		new_particle.global_position = global_position
		new_particle.global_rotation = global_rotation + 180
			
	elif area.is_in_group("oxygen"):
		on_eaten.emit()
		eaten += 1
		#$CanvasLayer/HBoxContainer/EatLabel.text = str(eaten)
		Bus.on_spike_collected.emit(area)
		$Eat.play()
		collect_oxygen(area)
	elif area.is_in_group("star"):
		area.capture_me()
		Bus.on_star_collected.emit(area)
	elif area.is_in_group("flutter"):
		area.queue_free()
		Bus.on_flutter_collected.emit(area)
	elif area.is_in_group("respawn"):
		Bus.on_player_fell.emit(self)

func _on_area_2d_area_exited(area):
	if area.is_in_group("bubble"):
		wiggles_per_second = 0
		is_in_bubble = false
		$JumpOut.play()
		#var boost_ratio = self.global_position.distance_to(get_global_mouse_position()) / max_mouse_distance
		#print(boost_ratio)
		
		var direction_to_center = global_position.direction_to(area.global_position)
		var velocity_projection = velocity.dot(direction_to_center) * direction_to_center
		var velocity_against_edge = velocity - velocity_projection
		
		if velocity.length() > required_exit_velocity:
			var new_splash = splash_packed.instantiate()
			area.add_child(new_splash)
			new_splash.global_position = global_position
			new_splash.global_rotation = global_rotation 

			velocity = velocity * exit_water_boost 
		else:
			$FailOut.play()
			velocity = -velocity
