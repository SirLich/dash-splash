extends ColorRect

func _ready():
	Bus.on_player_fell.connect(on_player_fell)
	
func on_player_fell(player : Player):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(-.0, 0.0, 0.0, 1.0), 1.0)
	tween.tween_property(self, "color", Color(-.0, 0.0, 0.0, 0.0), 1.0)
