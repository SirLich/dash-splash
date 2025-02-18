@tool

extends Node2D
class_name Bubble

@export var initial_size = 1.0 :
	get:
		return initial_size
	set(value):
		if value != initial_size:
			initial_size = value
			set_size()
			
@export var float_magnitude = 30
@export var float_time = 3.0

@export var size_override = -1

@export var is_special = false

func get_size_display():
	if is_special:
		return 20
	return initial_size
	
var default_scale_sprite = 1.0
var default_scale_shape = 109

@export var node : Node2D
@export var shape : CollisionShape2D

func tween_up(direction):
	await get_tree().create_timer(randf_range(0.0, float_time * 2)).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * float_magnitude), float_time)
	tween.tween_property(self, "global_position", global_position - (Vector2.UP * float_magnitude), float_time)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()

func set_size():
	set_bubble_scale(initial_size)

@export var highlight : AnimatedSprite2D
@export var use_animations = true

func _ready():
	if use_animations:
		node.rotation_degrees = randf_range(0.0, 360.0)
		highlight.play(["anim_1", "anim_2"].pick_random())
		set_bubble_scale(initial_size)
		if !Engine.is_editor_hint():
			tween_up(1.0)

# 1.0 is normal, 2.0 is double, etc.
func set_bubble_scale(size):
	var new_node_scale = default_scale_sprite * size
	node.scale = Vector2(new_node_scale, new_node_scale)
	
	shape.shape.radius = default_scale_shape * size
	
	
	
