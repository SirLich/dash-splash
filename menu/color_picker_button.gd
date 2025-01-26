extends Control

@onready var color_picker_button = $ColorPickerButton  # Reference to the ColorPickerButton

func _ready():
	color_picker_button.color_changed.connect(_on_color_changed)

func _on_color_changed(new_color: Color):
	color_picker_button.color = new_color
	Bus.set_color(new_color)
