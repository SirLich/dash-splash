extends Node2D

@export var sprite : AnimatedSprite2D

func _ready():
	sprite.play("splash")
	
func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
