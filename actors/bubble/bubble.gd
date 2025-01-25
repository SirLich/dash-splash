extends Node2D

@export var initial_size = 1.0
@export var float_magnitude = 30
@export var float_time = 3.0


var default_scale_sprite : float
var default_scale_shape : float

@export var sprite : Sprite2D
@export var shape : CollisionShape2D

func tween_up(direction):
	await get_tree().create_timer(randf_range(0.0, float_time * 2)).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * float_magnitude), float_time)
	tween.tween_property(self, "global_position", global_position - (Vector2.UP * float_magnitude), float_time)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
	
func _ready():
	default_scale_sprite = sprite.scale.x
	default_scale_shape = shape.shape.radius
	set_bubble_scale(initial_size)
	tween_up(1.0)
	
# 1.0 is normal, 2.0 is double, etc.
func set_bubble_scale(size):
	var new_sprite_scale = default_scale_sprite * size
	sprite.scale = Vector2(new_sprite_scale, new_sprite_scale)
	
	shape.shape.radius = default_scale_shape * size
	
	
	
