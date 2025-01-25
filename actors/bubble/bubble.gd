extends Node2D

@export var initial_size = 1.0

var default_scale_sprite : float
var default_scale_shape : float

@export var sprite : Sprite2D
@export var shape : CollisionShape2D

func _ready():
	default_scale_sprite = sprite.scale.x
	default_scale_shape = shape.shape.radius
	set_bubble_scale(initial_size)
	
# 1.0 is normal, 2.0 is double, etc.
func set_bubble_scale(size):
	var new_sprite_scale = default_scale_sprite * size
	sprite.scale = Vector2(new_sprite_scale, new_sprite_scale)
	
	shape.shape.radius = default_scale_shape * size
	
	
	
