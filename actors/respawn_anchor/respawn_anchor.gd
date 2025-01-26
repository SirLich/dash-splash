extends Node2D
class_name RespawnAnchor

@export var deactive_color : Color
@export var active_color : Color
@export var inside : Node2D

@export var is_active = false

func _ready():
	set_active(is_active)
		
func set_active(new_active):
	is_active = new_active
	
	if is_active:
		inside.modulate = active_color
	else:
		inside.modulate = deactive_color

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		if not is_active:
			get_parent().set_anchor_active(self)
			
