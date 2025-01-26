extends Node2D
class_name RespawnManager

func _ready():
	Bus.on_player_fell.connect(on_player_fell)
	
func on_player_fell(player : Player):
	await get_tree().create_timer(1.0).timeout
	$AudioStreamPlayer.play()
	player.global_position = get_active_anchor().global_position
	player.velocity = Vector2(0.0, 0.0)
	
func get_active_anchor():
	for child in get_children():
		if child is AudioStreamPlayer:
			continue
		if child.is_active:
			return child
	return null
	
func set_anchor_active(anchor: RespawnAnchor):
	for child in get_children():
		if child is AudioStreamPlayer:
			continue
		if child == anchor:
			child.set_active(true)
		else:
			child.set_active(false)
