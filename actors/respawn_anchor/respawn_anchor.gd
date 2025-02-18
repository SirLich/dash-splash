extends Node2D
class_name RespawnAnchor

@export var deactive_color : Color
@export var active_color : Color
@export var inside : Node2D

@export var is_active = false

func _ready():
	if is_active:
		inside.modulate = active_color
		$Graphics/AnimatedSprite2D.play("opening")
		await $Graphics/AnimatedSprite2D.animation_finished
		$Graphics/AnimatedSprite2D.play("open")

	else:
		$Graphics/AnimatedSprite2D.play("default")
		inside.modulate = deactive_color
		
func set_active(new_active):
	$AudioStreamPlayer.play()
	is_active = new_active
	
	if is_active:
		inside.modulate = active_color
		$Graphics/AnimatedSprite2D.play("opening")
		await $Graphics/AnimatedSprite2D.animation_finished
		$Graphics/AnimatedSprite2D.play("open")

	else:
		$Graphics/AnimatedSprite2D.play("default")
		inside.modulate = deactive_color
		
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		if not is_active:
			get_parent().set_anchor_active(self)
			
