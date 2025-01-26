extends Node2D
class_name Body

var snap_duration = 0.07
var following : Node2D
var head : Node2D

var follow_distance = 30

func _ready():
	modulate = Bus._color
	
var tween : Tween
func set_following(node : Node2D, snap: float, follow: float):
	following = node
	snap_duration = snap
	follow_distance = follow
	
func _process(delta):
	global_position = following.global_position + (following.global_transform.y * follow_distance)

	tween = get_tree().create_tween()
	var dir = lerp_angle(global_rotation, following.global_rotation, 1)
	tween.tween_property(self, "global_rotation", dir, snap_duration)
	
	var current_speed = head.velocity.length()
	var speed_ratio = current_speed / head.max_speed
	
	speed_ratio = clamp(speed_ratio, 0.0, 1.0)
	var rotation_amount = lerp(20, -30, speed_ratio)
	$LgFinSide1.rotation_degrees = speed_ratio * -rotation_amount
	$LgFinSide2.rotation_degrees = speed_ratio * rotation_amount
	
