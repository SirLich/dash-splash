extends Area2D

@export var anim : AnimatedSprite2D

func _ready():
	anim.play("default")
	
func capture_me():
	anim.play("grab")
	await anim.animation_finished
	queue_free()
	
