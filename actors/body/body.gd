extends Node2D
class_name Body

var snap_duration = 0.1
var following : Node2D
var head : Node2D

var follow_distance = 30

var tween : Tween
func set_following(node : Node2D, snap: float, follow: float):
	following = node
	snap_duration = snap
	follow_distance = follow
	
func _process(delta):
	global_position = following.global_position + (following.global_transform.y * follow_distance)

	tween = get_tree().create_tween()
	tween.tween_property(self, "global_rotation", following.global_rotation, snap_duration)
	
	var current_speed = head.velocity.length()
	var speed_ratio = current_speed / head.max_speed
	
	speed_ratio = clamp(speed_ratio, 0.0, 1.0)
	var rotation_amount = lerp(200, 0, speed_ratio)
	$LgFinSide1.rotation_degrees = speed_ratio * -rotation_amount
	$LgFinSide2.rotation_degrees = speed_ratio * rotation_amount
	
