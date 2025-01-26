extends Button

func _ready():
	pressed.connect(self.button_pressed)

func button_pressed():
	get_tree().quit()
