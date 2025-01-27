extends Sprite2D

@export var colors : Array[Color]
@export var scale_time = 2.8

var original_scale = Vector2()
func _ready():
	original_scale = scale
	modulate = colors.pick_random()
	await get_tree().create_timer(randf_range(0.0, scale_time)).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", original_scale * Vector2(0.8, 0.8), scale_time)
	tween.tween_property(self, "scale", original_scale, scale_time)
	tween.set_loops()
