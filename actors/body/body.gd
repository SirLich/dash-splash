extends Node2D
class_name Body

var snap_duration = 0.2
var following : Node2D
var follow_distance = 100

var tween : Tween

func set_following(node : Node2D, snap: float, follow: float):
	following = node
	snap_duration = snap
	follow_distance = follow
	
func _physics_process(delta):
	global_position = following.global_position + (following.global_transform.y * follow_distance)

	tween = get_tree().create_tween()
	tween.tween_property(self, "global_rotation", following.global_rotation, snap_duration)
