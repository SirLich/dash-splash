extends Node


var _color = Color("#aabb6c")
var _music_volume = 100.0
var _sound_volume = 100.0

func set_music_volume(volume: float):
	_music_volume = volume
	
func set_sound_volume(volume: float):
	_sound_volume = volume
	
func set_color(color : Color):
	_color = color

signal on_game_started
signal on_player_fell(player : Player)
signal on_star_collected(star : Node2D)
signal on_spike_collected(spike :Node2D)
signal on_flutter_collected
