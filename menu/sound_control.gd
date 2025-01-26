extends Control

@onready var music_control = $MusicSlider
@onready var sound_control = $SoundSlider

func _ready():
	music_control.value_changed.connect(_on_music_vol_changed)
	sound_control.value_changed.connect(_on_sound_vol_changed)

func _on_music_vol_changed(new_vol: float):
	Bus.set_music_volume(new_vol)

func _on_sound_vol_changed(new_vol: float):
	Bus.set_sound_volume(new_vol)
