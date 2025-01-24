extends Button

@export
var gamescene: PackedScene

func _ready():
	pressed.connect(self.button_pressed)

func button_pressed():
	get_tree().change_scene_to_packed(gamescene)
